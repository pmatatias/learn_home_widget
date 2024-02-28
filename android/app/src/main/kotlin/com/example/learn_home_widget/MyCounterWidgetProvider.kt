package com.example.learn_home_widget

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.net.Uri
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetBackgroundIntent
import es.antonborri.home_widget.HomeWidgetProvider

class MyCounterWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(
            context: Context,
            appWidgetManager: AppWidgetManager,
            appWidgetIds: IntArray,
            widgetData: SharedPreferences) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.my_counter_layout).apply {
                val count = widgetData.getInt("counter", 0)
                setTextViewText(R.id.text_counter, count.toString())

                val incrementIntent = HomeWidgetBackgroundIntent.getBroadcast(
                        context,
                        Uri.parse("teloletWidgetCounter://increment")
                )
                val clearIntent = HomeWidgetBackgroundIntent.getBroadcast(
                        context,
                        Uri.parse("teloletWidgetCounter://clear")
                )

                setOnClickPendingIntent(R.id.button_increment, incrementIntent)
                setOnClickPendingIntent(R.id.button_clear, clearIntent)
            }
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}