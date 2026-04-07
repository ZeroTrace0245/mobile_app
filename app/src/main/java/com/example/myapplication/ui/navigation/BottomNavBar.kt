package com.example.myapplication.ui.navigation

import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.vector.ImageVector

data class BottomNavItem(
    val label: String,
    val icon: ImageVector,
    val index: Int
)

@Composable
fun BottomNavBar(
    currentScreen: Int,
    onScreenChange: (Int) -> Unit
) {
    val items = listOf(
        BottomNavItem("Home", Icons.Filled.Home, 0),
        BottomNavItem("Health", Icons.Filled.MedicalServices, 1),
        BottomNavItem("AI Chat", Icons.Filled.AutoAwesome, 2),
        BottomNavItem("Meditate", Icons.Filled.FavoriteBorder, 3),
        BottomNavItem("Journal", Icons.Filled.Notes, 4)
    )

    NavigationBar {
        items.forEach { item ->
            NavigationBarItem(
                icon = { Icon(item.icon, contentDescription = item.label) },
                label = { Text(item.label) },
                selected = currentScreen == item.index,
                onClick = { onScreenChange(item.index) }
            )
        }
    }
}
