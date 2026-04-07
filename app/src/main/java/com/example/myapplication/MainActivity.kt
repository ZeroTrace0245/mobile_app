package com.example.myapplication

import android.app.PendingIntent
import android.content.Intent
import android.nfc.NdefMessage
import android.nfc.NfcAdapter
import android.nfc.Tag
import android.os.Bundle
import android.widget.Toast
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.animation.Crossfade
import androidx.compose.animation.core.tween
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Scaffold
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import com.example.myapplication.data.AiService
import com.example.myapplication.data.AppDatabase
import com.example.myapplication.data.FirebaseSyncRepository
import com.example.myapplication.data.HealthRecord
import com.example.myapplication.data.MockData
import com.example.myapplication.data.SettingsRepository
import com.example.myapplication.ui.screens.*
import com.example.myapplication.ui.theme.MyApplicationTheme
import com.example.myapplication.ui.navigation.BottomNavBar
import com.example.myapplication.util.NfcHandler
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.launch

class MainActivity : ComponentActivity() {
    private var nfcAdapter: NfcAdapter? = null
    private var pendingNdefMessage = mutableStateOf<NdefMessage?>(null)

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        nfcAdapter = NfcAdapter.getDefaultAdapter(this)
        
        val database = AppDatabase.getInstance(applicationContext)
        val firebaseSync = FirebaseSyncRepository()
        val settingsRepository = SettingsRepository(applicationContext)
        val aiService = AiService { 
            settingsRepository.githubToken.first()?.takeIf { it.isNotBlank() } 
                ?: settingsRepository.getFallbackToken() 
        }
        
        enableEdgeToEdge()
        setContent {
            MyApplicationTheme {
                Surface(
                    modifier = Modifier.fillMaxSize(),
                    color = MaterialTheme.colorScheme.background
                ) {
                    val bypassLogin = false // Set to true to skip all screens and use mock data
                    
                    var currentAppStep by remember { 
                        mutableStateOf(if (bypassLogin) "main" else "login") 
                    }
                    var userName by remember { 
                        mutableStateOf<String?>(if (bypassLogin) "John Doe" else null) 
                    }
                    var userProfile by remember { 
                        mutableStateOf<HealthRecord?>(if (bypassLogin) MockData.getMockProfile() else null) 
                    }
                    val scope = rememberCoroutineScope()

                    Crossfade(
                        targetState = currentAppStep,
                        animationSpec = tween(durationMillis = 800),
                        label = "main_navigation"
                    ) { step ->
                        when (step) {
                            "login" -> {
                                LoginScreen(
                                    onLoginComplete = { name ->
                                        userName = name
                                        currentAppStep = "registration"
                                    },
                                    onDebugLogin = {
                                        val mock = MockData.getMockProfile()
                                        userName = mock.personalInfo.name
                                        userProfile = mock
                                        currentAppStep = "main"
                                    }
                                )
                            }
                            "registration" -> {
                                RegistrationScreen(
                                    onRegistrationComplete = { record ->
                                        userProfile = record
                                        scope.launch {
                                            database.healthRecordDao().insertHealthRecord(record)
                                        }
                                        currentAppStep = "main"
                                    },
                                    onViewPolicies = { currentAppStep = "policies" }
                                )
                            }
                            "policies" -> {
                                PoliciesScreen(onBack = { currentAppStep = "registration" })
                            }
                            "main" -> {
                                HealthWellnessApp(
                                    database = database, 
                                    firebaseSync = firebaseSync, 
                                    userName = userName ?: "User", 
                                    userProfile = userProfile,
                                    aiService = aiService,
                                    settingsRepository = settingsRepository,
                                    onWriteNfc = { record ->
                                        if (nfcAdapter == null) {
                                            Toast.makeText(this@MainActivity, "NFC not supported", Toast.LENGTH_SHORT).show()
                                        } else if (!nfcAdapter!!.isEnabled) {
                                            Toast.makeText(this@MainActivity, "Please enable NFC", Toast.LENGTH_SHORT).show()
                                        } else {
                                            pendingNdefMessage.value = NfcHandler.createNdefMessage(record)
                                            Toast.makeText(this@MainActivity, "Hold your phone near an NFC tag", Toast.LENGTH_LONG).show()
                                        }
                                    }
                                )
                            }
                        }
                    }
                }
            }
        }
    }

    override fun onResume() {
        super.onResume()
        val intent = Intent(this, javaClass).addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP)
        val pendingIntent = PendingIntent.getActivity(this, 0, intent, PendingIntent.FLAG_MUTABLE)
        nfcAdapter?.enableForegroundDispatch(this, pendingIntent, null, null)
    }

    override fun onPause() {
        super.onPause()
        nfcAdapter?.disableForegroundDispatch(this)
    }

    @Suppress("DEPRECATION")
    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        if (NfcAdapter.ACTION_TAG_DISCOVERED == intent.action ||
            NfcAdapter.ACTION_NDEF_DISCOVERED == intent.action ||
            NfcAdapter.ACTION_TECH_DISCOVERED == intent.action) {
            
            val tag = intent.getParcelableExtra<Tag>(NfcAdapter.EXTRA_TAG)
            val message = pendingNdefMessage.value
            
            if (tag != null && message != null) {
                NfcHandler.writeTag(tag, message).fold(
                    onSuccess = {
                        Toast.makeText(this, "Successfully written to NFC tag!", Toast.LENGTH_SHORT).show()
                        pendingNdefMessage.value = null
                    },
                    onFailure = {
                        Toast.makeText(this, "Failed to write: ${it.message}", Toast.LENGTH_SHORT).show()
                    }
                )
            }
        }
    }
}

@Composable
fun HealthWellnessApp(
    database: AppDatabase, 
    firebaseSync: FirebaseSyncRepository, 
    userName: String,
    userProfile: HealthRecord?,
    aiService: AiService,
    settingsRepository: SettingsRepository,
    onWriteNfc: (HealthRecord) -> Unit
) {
    var currentScreen by remember { mutableIntStateOf(0) }
    var editingRecord by remember { mutableStateOf<HealthRecord?>(null) }
    val scope = rememberCoroutineScope()
    
    Scaffold(
        modifier = Modifier.fillMaxSize(),
        containerColor = MaterialTheme.colorScheme.background,
        bottomBar = {
            if (editingRecord == null) {
                BottomNavBar(
                    currentScreen = currentScreen,
                    onScreenChange = { 
                        currentScreen = it
                        editingRecord = null
                    }
                )
            }
        }
    ) { innerPadding ->
        if (editingRecord != null) {
            HealthProfileEditScreen(
                initialRecord = editingRecord!!,
                onSave = { record ->
                    scope.launch {
                        if (record.id == 0) {
                            database.healthRecordDao().insertHealthRecord(record)
                        } else {
                            database.healthRecordDao().updateHealthRecord(record)
                        }
                        firebaseSync.syncHealthRecord(record)
                        editingRecord = null
                    }
                },
                onBack = { editingRecord = null }
            )
        } else {
            when (currentScreen) {
                0 -> HomeScreen(
                    modifier = Modifier.padding(innerPadding), 
                    userName = userName,
                    userProfile = userProfile,
                    aiService = aiService,
                    onExportToNfc = onWriteNfc
                )
                1 -> HealthRecordsScreen(
                    modifier = Modifier.padding(innerPadding),
                    onEditProfile = { editingRecord = it },
                    onCreateProfile = { editingRecord = HealthRecord() }
                )
                2 -> ChatScreen(
                    aiService = aiService,
                    settingsRepository = settingsRepository,
                    modifier = Modifier.padding(innerPadding)
                )
                3 -> MeditationScreen(modifier = Modifier.padding(innerPadding))
                4 -> JournalScreen(modifier = Modifier.padding(innerPadding))
            }
        }
    }
}
