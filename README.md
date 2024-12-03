# todo_app

A new Flutter project for Managing Tasks.

## Getting Started

This project is a starting point for a Flutter application.

## Project Overview
This Flutter application provides a simple task management system with offline capabilities and synchronization with a backend server when internet connectivity is restored. Below is a summary of the app's features and functionality using clean architecture:

## Features
Create Tasks:
Users can create new tasks and store them locally using SQLite.
Tasks include fields such as title, description, and status.

Edit Tasks:
Users can update the details of an existing task (e.g., title, description, or status).
Changes are saved locally.

Delete Tasks:
Users can remove tasks, and the deletion is saved locally.
Offline-First Functionality

Tasks are saved locally, allowing users to manage their tasks even without an internet connection.
Backend Synchronization

When internet connectivity is restored, local tasks are synchronized with the backend server.
Synchronization includes creating, updating, and deleting tasks on the server.
Task List View

Users can view their tasks in a neatly organized list view, with options for interaction (edit, delete, etc.).


## Technical Summary
Local Storage:
Tasks are stored locally using the sqflite package for SQLite database integration.

Backend Synchronization:
Synchronization is achieved using REST APIs with the dio package for HTTP requests.
Tasks with the isSynced = false flag are queued for syncing when connectivity is restored.

Network Connectivity:
The app monitors internet connectivity using the connectivity_plus package.
When connectivity is restored, local data is automatically synchronized with the backend.

State Management:
Application state is managed using the flutter_bloc package for a clean and reactive architecture.

List View:
Tasks are displayed in a scrollable ListView with support for dynamic updates.

## Package Details
1 flutter_slidable: Adds slideable widgets for list items, enabling swipe actions like delete, edit, etc.
2 google_fonts:Provides access to Google Fonts.
3 intl: Supports internationalization and formatting for dates, numbers, and currencies.
4 sqflite: Enables local database storage using SQLite for data persistence.
5 dio: A powerful HTTP client for making RESTful API requests.
6 pretty_dio_logger: Formats and logs HTTP requests and responses for easier debugging.
7 get_it: Implements dependency injection for managing app-wide services and instances.
8 dartz: Provides functional programming utilities like Either, Option, and more.
9 flutter_bloc: Manages application state using the BLoC (Business Logic Component) pattern.
10 path: Utilities for manipulating file system paths in a cross-platform manner.
11 connectivity_plus: Detects network connectivity status (WiFi, mobile, or offline).
12 http: Simplifies making RESTful API requests using HTTP.



