# CardioTwin 🫀

CardioTwin is a comprehensive digital health application built with **Flutter** that leverages on-device Machine Learning (via TensorFlow Lite) to perform advanced **Cardiac Risk Assessment**. Designed for both patients and healthcare providers, it evaluates acute and chronic cardiovascular risks to deliver actionable insights directly on the device, ensuring privacy and speed.

## 🚀 Features

*   **Dual AI Risk Assessment**: Utilizes custom-trained TFLite neural networks for two distinct pipelines:
    *   **Acute Risk Model** (Heart Disease immediate risk)
    *   **Chronic Risk Model** (Long-term Cardiac Failure risk)
*   **On-Device Inference**: No patient health data leaves the device for risk calculations. All ML inferences run locally using `tflite_flutter`.
*   **Dynamic Risk Scoring**: Combines acute and chronic predictions into an easy-to-understand percentage score and categorizes risk into `LOW`, `MODERATE`, and `HIGH` tiers.
*   **AI Insights Dashboard**: A detailed breakdown of the patient's risk profile, highlighting key contributing factors, confidence metrics, and personalized, tailored summaries.
*   **Secure Authentication & Database**: Integrated with Firebase Authentication, Google Sign-In, and Cloud Firestore for secure user data management and app state architecture.

## 🧠 AI Model Architecture

The application packages two specialized models (`best_acute_risk_model.tflite` & `best_chronic_risk_model.tflite`) inside the `assets/models` directory. 

Features evaluated include:
*   Age, Sex
*   Resting Blood Pressure, Cholesterol, Glucose
*   Chest Pain Type, Resting ECG
*   Heart Rate, Exercise Angina, ST Slope
*   Lifestyle factors (Smoking, Alcohol, Physical Activity, BMI/Weight/Height)

## 🛠 Tech Stack

*   **Frontend**: Flutter (Dart)
*   **Machine Learning**: TensorFlow Lite (`tflite_flutter`)
*   **Backend & Auth**: Firebase (Auth, Firestore)
*   **State Management**: `provider` (AppProvider)

## 📦 Getting Started

### Prerequisites
*   Flutter SDK (^3.0.0 or higher recommended)
*   Android Studio / Xcode for emulators
*   Firebase project configured (with `google-services.json` / `GoogleService-Info.plist`)

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/your-repo/cardiotwin.git
   cd cardiotwin
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the Application:**
   ```bash
   flutter run
   ```

## 📂 Project Structure

*   `assets/models/`: Contains the `.tflite` model files and training data.
*   `lib/models/`: Dart data models (e.g., `model_config.dart` defining risk enums, ranges, and validation).
*   `lib/providers/`: State management (e.g., `AppProvider` storing inference results).
*   `lib/screens/`: UI views.
    *   `analysis/RiskResultScreen.dart`: Dynamic gauge and score display.
    *   `patient/AIInsightsScreen.dart`: Comprehensive factor breakdown and model confidence metrics.
    *   `common/LoadingScreen.dart`: Handles local TFLite inference before navigating to results.
*   `lib/services/`: Connective tissue and ML handling logic.

## 🛡️ Privacy & Security
CardioTwin is designed with patient privacy in mind. Risk assessment calculations are done entirely locally on the user's device using pre-trained models.

## 📄 License
This project is part of a Mobile Application Development Lab (MADL) assignment.
