# iTube
Youtube custom video player for uploaded videos, not live streamed videos.


# 📺 Flutter You-Tube Custom Player

A Flutter application that plays YouTube videos using **youtube_player_flutter**, supports **deep links**, and provides additional features such as:

* Full YouTube link parsing
* Play videos from shared links (Deep Link) from Youtube, using share ...
* Manual input & loading of YouTube links
* Full-screen mode with orientation handling
* Optional captions toggle
* YouTube progress indicator
* Clean error handling

This project is ideal for learning or integrating YouTube playback with mobile deep-linking in Flutter.

---

## 🚀 Features

### ✔️ YouTube Playback

* Plays any supported YouTube video using `YoutubePlayerController`
* Automatically loads the video when a link is detected

### ✔️ Deep Link Support

Detects YouTube URLs from:

* **App launch deep links**
* **Incoming stream deep links**
* **Platform channel (MethodChannel)** events

Supported formats:

* `https://www.youtube.com/watch?v=VIDEO_ID`
* `https://youtu.be/VIDEO_ID`
* Removes query parameters like `?si=` or timestamps


## 🧩 Project Structure

```
lib/
 └── youtube_player_screen.dart   # Main screen with deep linking + player logic
```

---

## 🔧 Dependencies

These packages are used:

```yaml
dependencies:
  flutter:
    sdk: flutter
  youtube_player_flutter: ^8.1.0
  app_links: ^4.0.0
```

Also uses:

* `MethodChannel` for native deep-link integration
* `SystemChrome` for UI mode & screen orientation


## 🧠 How It Works

### Deep Link Flow

1. User opens a YouTube link with your app
2. App parses the incoming URL
3. Extracts the YouTube video ID
4. Sanitizes URL (removes &si= or &t= params)
5. Loads the video through `YoutubePlayerController`

### Example URL Parsing

Supported links:

* `https://youtu.be/abcd1234`
* `https://youtube.com/watch?v=abcd1234&si=XYZ`
* `https://www.youtube.com/watch?v=abcd1234&t=60`

Everything is normalized to:

```
https://youtu.be/abcd1234
```

---

## 🖥️ Full Screen Behavior

When full-screen is enabled:

* UI enters **immersive mode**
* Orientation switches to **landscape**
* App bar disappears

When disabled:

* UI returns to normal
* Orientation resets to portrait

---

## ▶️ Running the App
Ensure you have Android Studio installed and JDK 17 is selected for Android phones.

Clone the repository:

```bash
git clone <repo_url>
cd project_folder
```

Install dependencies:

```bash
flutter pub get
```

Run the app:

```bash
flutter run
```

---

## 📄 License

This project is open-source.
Feel free to use, modify, and extend.
