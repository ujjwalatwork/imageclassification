# imageclassification

📱 Step 1: Get a pre-trained model
Use models like MobileNet (available from Apple)

🧠 Step 2: Add model to your project
Drag the .mlmodel file into Xcode

🖼️ Step 3: Pick an image
Use PhotosPicker (SwiftUI) to select an image from gallery

🔍 Step 4: Run prediction
Convert image → CIImage → pass it to Vision framework
Use VNCoreMLRequest to get predictions

📊 Step 5: Display result
Show top prediction with confidence score in UI

🛠️ Tech Stack:
• SwiftUI
• Core ML
• Vision Framework
