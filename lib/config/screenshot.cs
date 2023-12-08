using System;
using System.Drawing;
using System.Windows.Forms;

class Program
{
    [STAThread]
    static void Main()
    {
        ScreenCapture();
    }

    static void ScreenCapture()
    {
        // Get the bounds of the primary screen
        Rectangle bounds = Screen.PrimaryScreen.Bounds;

        // Create a bitmap of the appropriate size to receive the screenshot
        Bitmap screenshot = new Bitmap(bounds.Width, bounds.Height);

        // Create a graphics object from the bitmap
        using (Graphics graphics = Graphics.FromImage(screenshot))
        {
            // Capture the screenshot from the primary screen
            graphics.CopyFromScreen(Point.Empty, Point.Empty, bounds.Size);
        }

        // Save the screenshot to a file
        screenshot.Save("screenshot.jpg", System.Drawing.Imaging.ImageFormat.Jpeg);
    }
}