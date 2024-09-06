# Video Downloader GUI for FFmpeg

This project is a graphical interface for FFmpeg that allows users to retrieve the necessary URL from supported websites and synchronize it with the application to download video files.

## Limitations

- **In Development:** The project is currently in the early stages of development and has limited functionality.
- **Blob URLs Unsupported:** At this time, the application cannot retrieve URLs from `blob:` schemes.
- **Limited to macOS:** The app is only available on macOS for now.

## How to Download a Video

1. **Select Video:**
    - Open the extension pop-up and click on the "Select" button.
    - Move your cursor over the desired video on the webpage.
    - If the parser detects the video URL, a "Save" button will appear on the video.

2. **Save the Video URL:**
    - Click the "Save" button.
        - If the button turns **green**, the URL has been successfully saved.
        - If the button turns **red**, an error occurred and the URL could not be saved.
    - If the "Save" button does not appear, the parser is unable to detect a valid URL for the video.

3. **Sync with the Application:**
    - After saving the video, go back to the application and click the "Sync" button.
    - A card with the video URL should appear in the application.

4. **Download the Video:**
    - Enter a name for your video in the designated field.
    - Click the download icon or the "Download All" button to start downloading your video.

If you encounter issues where the "Save" button doesn't appear, it could mean the parser cannot find the required URL on the video.

## Planned Improvements

- Expanded support for more websites and platforms.
- Improved URL retrieval capabilities.
- Cross-platform compatibility.



Stay tuned for more updates!

