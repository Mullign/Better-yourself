import SwiftUI
import SwiftData
import UserNotifications

struct RemindersView: View {
    
    @AppStorage("ReminderTime") private var reminderTime: Double = Date().timeIntervalSince1970
    
    @AppStorage("RemindersOn") private var isRemindersOn = false
    @State private var selectedDate = Date().addingTimeInterval(86400)
    @State private var isSettingsDialogShowing = false
    
    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: selectedDate)
    }
    
    var body: some View {
        
        VStack(spacing: 20) {
            Text("Reminders")
                .font(.largeTitle)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("Remind yourself to do something uplifting everyday.")
                .frame(maxWidth: .infinity, alignment: .leading)
            
            
            Toggle(isOn: $isRemindersOn) {
                Text("Toggle reminders:")
            }
            
            if isRemindersOn {
                HStack {
                    Text("What time?")
                    Spacer()
                    DatePicker("", selection: $selectedDate, displayedComponents: .hourAndMinute)
                }
                
                // Tooltip saying when reminders are set for
                VStack(alignment: .leading, spacing: 10) {
                    Text(Image(systemName: "bell.and.waves.left.and.right"))
                    Text("You'll receive a friendly reminder at \(formattedTime) on selected days to make your day better.")
                }
                .foregroundStyle(Color.blue)
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(Color.blue, lineWidth: 1)
                        .background(Color("light-blue"))
                }
            }
            else {
                // Tooltip to turn reminders on
                ToolTipView(text: "Turn on reminders above to remind yourself to make each day better.")
            }
            
            Spacer()
            Image("Reminders")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 300)
            Spacer()
        }
        .padding(.trailing, 2)
        .onAppear(perform: {
            selectedDate = Date(timeIntervalSince1970: reminderTime)
        })
        .onChange(of: isRemindersOn) { oldValue, newValue in
            // Check for permissions to send notifications
            let notificationCenter = UNUserNotificationCenter.current()
            
            notificationCenter.getNotificationSettings { settings in
                switch settings.authorizationStatus {
                case .authorized:
                    print("Notifications are authorized.")
                    // Schedule the notifications
                    scheduleNotifications()
                case .denied:
                    print("Notifications are denied.")
                    isRemindersOn = false
                    // Show a dialog saying that we can't send notifications and have a button to send the user to Settings
                    isSettingsDialogShowing = true
                case .notDetermined:
                    print("Notification permission has not been asked yet.")
                    // Request it
                    requestNotificationPermission()
                default:
                    break
                }
            }
        }
        .onChange(of: selectedDate) { oldValue, newValue in
            let notificationCenter = UNUserNotificationCenter.current()
            
            // Unschedule all currently scheduled reminders
            notificationCenter.removeAllPendingNotificationRequests()
            
            // Schedule new reminders
            scheduleNotifications()
            
            // Save new time
            reminderTime = selectedDate.timeIntervalSince1970
        }
        .alert(isPresented: $isSettingsDialogShowing) {
            
            Alert(title: Text("Notifications Disabled"), message: Text("Reminders won't be sent unless Notifications are allowed. Please allow them in Settings."), primaryButton: .default(Text("Go to Settings"), action: {
                // Go to settings
                goToSettings()
            }), secondaryButton: .cancel())
        }
    }
    
    func goToSettings() {
        
        if let appSettings = URL(string: UIApplication.openSettingsURLString) {
            
            if UIApplication.shared.canOpenURL(appSettings) {
                
                UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
            }
        }
    }
    
    func requestNotificationPermission() {
        let notificationCenter = UNUserNotificationCenter.current()

        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Permission granted.")
                // Schedule the notifications
                scheduleNotifications()
                
            } else {
                print("Permission denied.")
                isRemindersOn = false
                // Show a dialog saying that we can't send notifications and have a button to send the user to Settings
                isSettingsDialogShowing = true
            }

            if let error = error {
                print("Error requesting permission: \(error.localizedDescription)")
            }
        }
    }
    
    func scheduleNotifications() {
        
        let notificationCenter = UNUserNotificationCenter.current()

        // Create the content of the notification
        let content = UNMutableNotificationContent()
        content.title = "A Better Day"
        content.body = "Don't forget to do something for yourself today!"
        content.sound = .default

        // Define the time components for the notification (8:00 AM in this case)
        var dateComponents = DateComponents()
        dateComponents.hour = Calendar.autoupdatingCurrent.component(.hour, from: selectedDate)
        dateComponents.minute = Calendar.autoupdatingCurrent.component(.minute, from: selectedDate)

        // Create a trigger that repeats every day at the specified time
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        // Create the notification request with a unique identifier
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        // Schedule the notification
        notificationCenter.add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Daily notification scheduled.")
            }
        }
    }
}

#Preview {
    RemindersView()
}
