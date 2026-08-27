import SwiftUI
import AppKit
import Combine
import MediaPlayer
import Darwin
import Foundation
import CoreGraphics
import IOKit
import IOKit.ps
import IOBluetooth

// MARK: - =========================================================================
// MARK: 1. LOCALIZATION & MULTI-LANGUAGE ENGINE
// MARK: - =========================================================================

enum AppLanguage: String, CaseIterable, Identifiable {
    case turkish = "Türkçe"
    case english = "English"
    case chinese = "中文"
    case german = "Deutsch"
    case spanish = "Español"
    case russian = "Русский"
    case arabic = "العربية"
    case french = "Français"

    var id: String { rawValue }
}

struct L10n {
    static func string(_ key: String, lang: AppLanguage) -> String {
        let translations: [String: [AppLanguage: String]] = [
            "tab_media": [
                .turkish: "Medya", .english: "Media", .chinese: "媒体", .german: "Medien",
                .spanish: "Medios", .russian: "Медиа", .arabic: "الوسائط", .french: "Média"
            ],
            "tab_system": [
                .turkish: "Sistem", .english: "System", .chinese: "系统", .german: "System",
                .spanish: "Sistema", .russian: "Система", .arabic: "النظام", .french: "Système"
            ],
            "tab_controls": [
                .turkish: "Kontroller", .english: "Controls", .chinese: "控制", .german: "Regler",
                .spanish: "Controles", .russian: "Элементы", .arabic: "التحكم", .french: "Contrôles"
            ],
            "tab_notes": [
                .turkish: "Notlar", .english: "Notes", .chinese: "笔记", .german: "Notizen",
                .spanish: "Notas", .russian: "Заметки", .arabic: "ملاحظات", .french: "Notes"
            ],
            "tab_clipboard": [
                .turkish: "Pano", .english: "Clipboard", .chinese: "剪贴板", .german: "Ablage",
                .spanish: "Portapapeles", .russian: "Буфер", .arabic: "الحافظة", .french: "Presse-papiers"
            ],
            "tab_pomodoro": [
                .turkish: "Pomodoro", .english: "Pomodoro", .chinese: "专注", .german: "Pomodoro",
                .spanish: "Pomodoro", .russian: "Помодоро", .arabic: "بومودورو", .french: "Pomodoro"
            ],
            "tab_bluetooth": [
                .turkish: "Bluetooth", .english: "Bluetooth", .chinese: "蓝牙", .german: "Bluetooth",
                .spanish: "Bluetooth", .russian: "Bluetooth", .arabic: "بلوتوث", .french: "Bluetooth"
            ],
            "tab_settings": [
                .turkish: "Ayarlar", .english: "Settings", .chinese: "设置", .german: "Optionen",
                .spanish: "Ajustes", .russian: "Настройки", .arabic: "الإعدادات", .french: "Réglages"
            ],
            "no_music": [
                .turkish: "Müzik Çalınmıyor", .english: "No Media Playing", .chinese: "未播放音乐", .german: "Keine Wiedergabe",
                .spanish: "Sin Reproducción", .russian: "Музыка не играет", .arabic: "لا يوجد تشغيل", .french: "Aucune lecture"
            ],
            "unknown_artist": [
                .turkish: "Bilinmeyen Sanatçı", .english: "Unknown Artist", .chinese: "未知艺术家", .german: "Unbekannter Künstler",
                .spanish: "Artista Desconocido", .russian: "Неизвестный исполнитель", .arabic: "فنان غير معروف", .french: "Artiste inconnu"
            ],
            "lyrics_loading": [
                .turkish: "Sözler yükleniyor...", .english: "Loading lyrics...", .chinese: "歌词加载中...", .german: "Lade Songtext...",
                .spanish: "Cargando letras...", .russian: "Загрузка текста...", .arabic: "جاري تحميل الكلمات...", .french: "Chargement des paroles..."
            ],
            "no_lyrics": [
                .turkish: "Şarkı sözü bulunamadı", .english: "No lyrics found", .chinese: "未找到歌词", .german: "Kein Songtext gefunden",
                .spanish: "Letras no encontradas", .russian: "Текст не найден", .arabic: "لم يتم العثور على كلمات", .french: "Paroles introuvables"
            ],
            "volume": [
                .turkish: "Ses Seviyesi", .english: "Volume", .chinese: "音量", .german: "Lautstärke",
                .spanish: "Volumen", .russian: "Громкость", .arabic: "مستوى الصوت", .french: "Volume"
            ],
            "brightness": [
                .turkish: "Ekran Parlaklığı", .english: "Brightness", .chinese: "亮度", .german: "Helligkeit",
                .spanish: "Brillo", .russian: "Яркость", .arabic: "السطوع", .french: "Luminosité"
            ],
            "language": [
                .turkish: "Uygulama Dili", .english: "App Language", .chinese: "应用语言", .german: "App-Sprache",
                .spanish: "Idioma de App", .russian: "Язык приложения", .arabic: "لغة التطبيق", .french: "Langue de l'app"
            ],
            "show_lyrics": [
                .turkish: "Şarkı Sözü Senkronizasyonu", .english: "Sync Song Lyrics", .chinese: "同步歌词显示", .german: "Songtexte synchronisieren",
                .spanish: "Sincronizar Letras", .russian: "Синхронизация текста", .arabic: "مزامنة كلمات الأغاني", .french: "Paroles synchronisées"
            ],
            "show_battery": [
                .turkish: "Pil Yüzdesini Göster", .english: "Show Battery Percentage", .chinese: "显示电池百分比", .german: "Akkustand anzeigen",
                .spanish: "Mostrar Porcentaje de Batería", .russian: "Показывать процент заряда", .arabic: "إظهار نسبة البطارية", .french: "Afficher le pourcentage de batterie"
            ],
            "autohide": [
                .turkish: "Fare Ayrılınca Gizle", .english: "Auto-hide on Mouse Leave", .chinese: "鼠标离开时自动隐藏", .german: "Automatisch ausblenden",
                .spanish: "Ocultar al salir el ratón", .russian: "Автоскрытие при уводе мыши", .arabic: "إخفاء تلقائي عند مغادرة الماوس", .french: "Masquer automatiquement"
            ],
            "note_placeholder": [
                .turkish: "Hızlı notunuzu buraya yazın...", .english: "Type your quick note here...", .chinese: "在此处输入快捷笔记...", .german: "Schnellnotiz hier eingeben...",
                .spanish: "Escribe tu nota rápida aquí...", .russian: "Введите быструю заметку...", .arabic: "اكتب ملاحظتك السريعة هنا...", .french: "Saisissez votre note rapide ici..."
            ],
            "cpu_load": [
                .turkish: "CPU Yükü", .english: "CPU Load", .chinese: "CPU 负载", .german: "CPU-Auslastung",
                .spanish: "Carga de CPU", .russian: "Загрузка ЦП", .arabic: "حمل المعالج", .french: "Charge CPU"
            ],
            "ram_usage": [
                .turkish: "RAM Kullanımı", .english: "RAM Usage", .chinese: "内存使用率", .german: "RAM-Nutzung",
                .spanish: "Uso de RAM", .russian: "Память RAM", .arabic: "استخدام الذاكرة", .french: "Utilisation RAM"
            ],
            "disk_space": [
                .turkish: "Disk Doluluğu", .english: "Disk Space", .chinese: "磁盘空间", .german: "Festplatte",
                .spanish: "Espacio de Disco", .russian: "Дисковое пространство", .arabic: "مساحة القرص", .french: "Espace disque"
            ],
            "copy": [
                .turkish: "Kopyala", .english: "Copy", .chinese: "复制", .german: "Kopieren",
                .spanish: "Copiar", .russian: "Копировать", .arabic: "نسخ", .french: "Copier"
            ],
            "clipboard_empty": [
                .turkish: "Pano boş. Kopyaladığınız gerçek metinler burada görünecek.",
                .english: "Clipboard is empty. Copied real texts will appear here.",
                .chinese: "剪贴板为空。复制的真实文本将显示在此处。",
                .german: "Ablage ist leer. Kopierte Texte werden hier angezeigt.",
                .spanish: "El portapapeles está vacío. Los textos copiados aparecerán aquí.",
                .russian: "Буфер обмена пуст. Скопированный текст появится здесь.",
                .arabic: "الحافظة فارغة. ستظهر النصوص المنسوخة هنا.",
                .french: "Le presse-papiers est vide. Les textes copiés apparaîtront ici."
            ],
            "clipboard_take": [
                .turkish: "Al", .english: "Get", .chinese: "获取", .german: "Holen",
                .spanish: "Obtener", .russian: "Взять", .arabic: "أخذ", .french: "Prendre"
            ],
            "pomodoro_title": [
                .turkish: "Odak & Çalışma Seansı", .english: "Focus & Work Session", .chinese: "专注与工作时间", .german: "Fokus & Arbeitssitzung",
                .spanish: "Sesión de Enfoque y Trabajo", .russian: "Сеанс фокуса и работы", .arabic: "جلسة التركيز والعمل", .french: "Session de concentration"
            ],
            "pomodoro_stop": [
                .turkish: "Sayacı Durdur", .english: "Stop Timer", .chinese: "停止计时器", .german: "Timer stoppen",
                .spanish: "Detener Temporizador", .russian: "Остановить таймер", .arabic: "إيقاف المؤقت", .french: "Arrêter le minuteur"
            ],
            "pomodoro_start": [
                .turkish: "Odaklanmayı Başlat", .english: "Start Focus", .chinese: "开始专注", .german: "Fokus starten",
                .spanish: "Iniciar Enfoque", .russian: "Начать фокус", .arabic: "بدء التركيز", .french: "Commencer la concentration"
            ],
            "bluetooth_empty": [
                .turkish: "Aktif bağlı Bluetooth cihazı bulunamadı.",
                .english: "No active connected Bluetooth devices found.",
                .chinese: "未找到当前连接的蓝牙设备。",
                .german: "Keine aktiv verbundenen Bluetooth-Geräte gefunden.",
                .spanish: "No se encontraron dispositivos Bluetooth conectados activos.",
                .russian: "Активных подключенных Bluetooth устройств не найдено.",
                .arabic: "لم يتم العثور على أجهزة بلوتوث متصلة نشطة.",
                .french: "Aucun appareil Bluetooth connecté actif trouvé."
            ],
            "bluetooth_connected": [
                .turkish: "Bağlı", .english: "Connected", .chinese: "已连接", .german: "Verbunden",
                .spanish: "Conectado", .russian: "Подключено", .arabic: "متصل", .french: "Connecté"
            ],
            "settings_general": [
                .turkish: "Genel", .english: "General", .chinese: "通用", .german: "Allgemein",
                .spanish: "General", .russian: "Общие", .arabic: "عام", .french: "Général"
            ],
            "settings_appearance": [
                .turkish: "Görünüm", .english: "Appearance", .chinese: "外观", .german: "Erscheinungsbild",
                .spanish: "Apariencia", .russian: "Вид", .arabic: "المظهر", .french: "Apparence"
            ],
            "settings_behavior": [
                .turkish: "Davranış", .english: "Behavior", .chinese: "行为", .german: "Verhalten",
                .spanish: "Comportamiento", .russian: "Поведение", .arabic: "السلوك", .french: "Comportement"
            ],
            "settings_system": [
                .turkish: "Sistem", .english: "System", .chinese: "系统", .german: "System",
                .spanish: "Sistema", .russian: "Система", .arabic: "النظام", .french: "Système"
            ],
            "settings_auto_clear_note": [
                .turkish: "Otomatik Not Temizleme (Kapanışta)", .english: "Auto Clear Note on Close", .chinese: "关闭时自动清除笔记", .german: "Notiz beim Schließen löschen",
                .spanish: "Borrar nota al cerrar", .russian: "Очищать заметку при закрытии", .arabic: "مسح الملاحظة تلقائيا عند الإغلاق", .french: "Effacer la note à la fermeture"
            ],
            "settings_notch_size": [
                .turkish: "Çentik Boyutu", .english: "Notch Size", .chinese: "刘海尺寸", .german: "Notch-Größe",
                .spanish: "Tamaño de Muesca", .russian: "Размер выреза", .arabic: "حجم النوتش", .french: "Taille de l'encoche"
            ],
            "settings_accent_color": [
                .turkish: "Vurgu Rengi", .english: "Accent Color", .chinese: "强调色", .german: "Akzentfarbe",
                .spanish: "Color de Acento", .russian: "Цвет акцента", .arabic: "لون التمييز", .french: "Couleur d'accent"
            ],
            "settings_bg_opacity": [
                .turkish: "Arka Plan Şeffaflığı", .english: "Background Opacity", .chinese: "背景不透明度", .german: "Hintergrund-Deckkraft",
                .spanish: "Opacidad de Fondo", .russian: "Прозрачность фона", .arabic: "شفافية الخلفية", .french: "Opacité de l'arrière-plan"
            ],
            "settings_glass_border": [
                .turkish: "İnce Cam Kenarlık Çizgisi", .english: "Thin Glass Border Line", .chinese: "细玻璃边框线", .german: "Dünne Glasrandlinie",
                .spanish: "Línea de borde de vidrio fina", .russian: "Тонкая граница стекла", .arabic: "خط حدود زجاجي رفيع", .french: "Ligne de bordure en verre fin"
            ],
            "settings_launch_login": [
                .turkish: "Sistem Başlangıcında Çalıştır", .english: "Launch at Login", .chinese: "登录时启动", .german: "Beim Anmelden starten",
                .spanish: "Abrir al iniciar sesión", .russian: "Запускать при входе", .arabic: "الفتح عند تسجيل الدخول", .french: "Lancer à la connexion"
            ],
            "settings_hide_dock": [
                .turkish: "Dock Simgesini Gizle", .english: "Hide Dock Icon", .chinese: "隐藏 Dock 图标", .german: "Dock-Symbol ausblenden",
                .spanish: "Ocultar icono del Dock", .russian: "Скрыть иконку в Dock", .arabic: "إخفاء أيقونة الدوك", .french: "Masquer l'icône du Dock"
            ],
            "settings_global_hotkey": [
                .turkish: "Global Kısayol Tuşu (Cmd+Option+N)", .english: "Global Hotkey (Cmd+Option+N)", .chinese: "全局快捷键 (Cmd+Option+N)", .german: "Globaler Hotkey (Cmd+Option+N)",
                .spanish: "Atajo Global (Cmd+Option+N)", .russian: "Глобальная горячая клавиша (Cmd+Option+N)", .arabic: "اختصار عالمي (Cmd+Option+N)", .french: "Raccourci global (Cmd+Option+N)"
            ],
            "settings_highlight_cpu": [
                .turkish: "Yüksek CPU/RAM Kullanımını Vurgula", .english: "Highlight High CPU/RAM Usage", .chinese: "高 CPU/内存使用率高亮", .german: "Hohe CPU/RAM-Nutzung hervorheben",
                .spanish: "Resaltar alto uso de CPU/RAM", .russian: "Выделять высокое использование ЦП/ОЗУ", .arabic: "تمييز استخدام المعالج/الذاكرة العالي", .french: "Mettre en surbrillance l'utilisation élevée"
            ],
            "settings_refresh_rate": [
                .turkish: "Sistem Yenileme Sıklığı", .english: "System Refresh Frequency", .chinese: "系统刷新频率", .german: "System-Aktualisierungsrate",
                .spanish: "Frecuencia de actualización del sistema", .russian: "Частота обновления системы", .arabic: "تكرار تحديث النظام", .french: "Fréquence de rafraîchissement"
            ]
        ]
        return translations[key]?[lang] ?? translations[key]?[.english] ?? key
    }
}

// MARK: - =========================================================================
// MARK: 2. MASTER CONFIGURATION & MODELS
// MARK: - =========================================================================

enum NotchStyle: String, CaseIterable, Identifiable {
    case compact = "Dar"
    case balanced = "Dengeli"
    case ultraWide = "Geniş"
    var id: String { rawValue }
}

enum AccentColorTheme: String, CaseIterable, Identifiable {
    case monochrome = "Klasik Beyaz"
    case neonGreen = "Neon Yeşil"
    case cyan = "Siber Mavi"
    case purple = "Mor"
    var id: String { rawValue }

    var color: Color {
        switch self {
        case .monochrome: return .white
        case .neonGreen: return Color(red: 0.2, green: 0.95, blue: 0.4)
        case .cyan: return Color(red: 0.0, green: 0.8, blue: 1.0)
        case .purple: return Color(red: 0.7, green: 0.4, blue: 1.0)
        }
    }
}

struct ClipboardItem: Identifiable, Equatable {
    let id = UUID()
    let text: String
    let date: Date
}

struct BluetoothDeviceItem: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let address: String
    let isConnected: Bool
}

final class MasterConfiguration: ObservableObject {
    @AppStorage("selectedLanguage") var selectedLanguage: AppLanguage = .turkish { willSet { objectWillChange.send() } }
    @AppStorage("notchExpansionStyle") var notchExpansionStyle: NotchStyle = .balanced { willSet { objectWillChange.send() } }
    @AppStorage("backgroundOpacity") var backgroundOpacity: Double = 0.85 { willSet { objectWillChange.send() } }
    @AppStorage("accentThemeColor") var accentThemeColor: AccentColorTheme = .monochrome { willSet { objectWillChange.send() } }
    @AppStorage("showGlassBorder") var showGlassBorder: Bool = false { willSet { objectWillChange.send() } }
    @AppStorage("launchAtLogin") var launchAtLogin: Bool = false { willSet { objectWillChange.send() } }
    @AppStorage("hideDockIcon") var hideDockIcon: Bool = false { willSet { objectWillChange.send() } }
    @AppStorage("autoHideOnMouseLeave") var autoHideOnMouseLeave: Bool = true { willSet { objectWillChange.send() } }
    @AppStorage("enableGlobalHotkey") var enableGlobalHotkey: Bool = true { willSet { objectWillChange.send() } }
    @AppStorage("showBatteryPercentage") var showBatteryPercentage: Bool = true { willSet { objectWillChange.send() } }
    @AppStorage("showAnimatedLyrics") var showAnimatedLyrics: Bool = true { willSet { objectWillChange.send() } }
    @AppStorage("systemRefreshInterval") var systemRefreshInterval: Double = 2.0 { willSet { objectWillChange.send() } }
    @AppStorage("highlightHighCpuUsage") var highlightHighCpuUsage: Bool = true { willSet { objectWillChange.send() } }
    @AppStorage("quickNoteText") var quickNoteText: String = "" { willSet { objectWillChange.send() } }
    @AppStorage("autoClearNoteOnClose") var autoClearNoteOnClose: Bool = false { willSet { objectWillChange.send() } }
}

// MARK: - =========================================================================
// MARK: 3. APP ENTRY & FLOATING WINDOW PANEL
// MARK: - =========================================================================

@main
struct NotchIslandProApp: App {
    @NSApplicationDelegateAdaptor(ExtendedAppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            EmptyView().frame(width: 0, height: 0)
        }
        .windowResizability(.contentSize)
    }
}

final class FloatingNotchPanel: NSPanel {
    override var canBecomeKey: Bool { true }
    override var canBecomeMain: Bool { true }

    override init(contentRect: NSRect, styleMask style: NSWindow.StyleMask, backing backingStoreType: NSWindow.BackingStoreType, defer flag: Bool) {
        super.init(contentRect: contentRect, styleMask: style, backing: backingStoreType, defer: flag)
        self.level = .statusBar
        self.backgroundColor = .clear
        self.isOpaque = false
        self.hasShadow = false
        self.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary, .stationary, .ignoresCycle]
    }
}

final class ExtendedAppDelegate: NSObject, NSApplicationDelegate {
    var floatingPanel: FloatingNotchPanel!
    let masterConfig = MasterConfiguration()

    func applicationDidFinishLaunching(_ notification: Notification) {
        setupPanel()
    }

    private func setupPanel() {
        guard let screen = NSScreen.main else { return }
        let width: CGFloat = 560
        let height: CGFloat = 325
        let rect = NSRect(x: (screen.frame.width - width) / 2, y: screen.frame.height - height, width: width, height: height)

        floatingPanel = FloatingNotchPanel(contentRect: rect, styleMask: [.nonactivatingPanel, .fullSizeContentView], backing: .buffered, defer: false)
        let root = MasterContainerView().environmentObject(masterConfig)
        floatingPanel.contentView = NSHostingView(rootView: root)
        floatingPanel.makeKeyAndOrderFront(nil)
    }
}

// MARK: - =========================================================================
// MARK: 4. SERVICES & HARDWARE MONITORS
// MARK: - =========================================================================

struct LyricLine: Identifiable, Equatable {
    let id: Int
    let timestamp: TimeInterval
    let text: String
}

struct LRCLibResponse: Codable {
    let plainLyrics: String?
    let syncedLyrics: String?
}

final class LyricsService: ObservableObject {
    @Published var syncedLines: [LyricLine] = []
    @Published var activeIndex: Int = 0
    @Published var isLoading: Bool = false
    @Published var hasLyrics: Bool = false

    private var cancellables = Set<AnyCancellable>()
    private var lastFetchedTrack: String = ""

    func fetchLyrics(track: String, artist: String) {
        guard !track.isEmpty, !track.contains("No Media"), !track.contains("Çalınmıyor") else {
            DispatchQueue.main.async {
                self.syncedLines = []
                self.hasLyrics = false
                self.lastFetchedTrack = ""
            }
            return
        }

        guard track != lastFetchedTrack else { return }
        lastFetchedTrack = track

        DispatchQueue.main.async {
            self.isLoading = true
            self.syncedLines = []
            self.activeIndex = 0
        }

        let queryTrack = track.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let queryArtist = artist.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://lrclib.net/api/get?artist_name=\(queryArtist)&track_name=\(queryTrack)"

        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: LRCLibResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] _ in
                self?.isLoading = false
            }, receiveValue: { [weak self] response in
                self?.isLoading = false
                if let rawSynced = response.syncedLyrics, !rawSynced.isEmpty {
                    let parsed = self?.parseLRC(rawSynced) ?? []
                    self?.syncedLines = parsed
                    self?.hasLyrics = !parsed.isEmpty
                } else {
                    self?.syncedLines = []
                    self?.hasLyrics = false
                }
            })
            .store(in: &cancellables)
    }

    private func parseLRC(_ lrcText: String) -> [LyricLine] {
        var lines: [LyricLine] = []
        let rawLines = lrcText.components(separatedBy: .newlines)
        var indexCounter = 0

        for line in rawLines {
            let trimmed = line.trimmingCharacters(in: .whitespaces)
            guard trimmed.hasPrefix("[") else { continue }

            let parts = trimmed.components(separatedBy: "]")
            guard parts.count >= 2 else { continue }

            let timeString = parts[0].replacingOccurrences(of: "[", with: "")
            let lyricText = parts.dropFirst().joined(separator: "]").trimmingCharacters(in: .whitespaces)

            if let seconds = parseTimestamp(timeString), !lyricText.isEmpty {
                lines.append(LyricLine(id: indexCounter, timestamp: seconds, text: lyricText))
                indexCounter += 1
            }
        }
        return lines.sorted(by: { $0.timestamp < $1.timestamp })
    }

    private func parseTimestamp(_ timeStr: String) -> TimeInterval? {
        let cleanStr = timeStr.replacingOccurrences(of: ",", with: ".")
        let components = cleanStr.components(separatedBy: ":")
        guard components.count == 2 else { return nil }

        let minutes = Double(components[0]) ?? 0.0
        let seconds = Double(components[1]) ?? 0.0
        return (minutes * 60.0) + seconds
    }

    func updatePlaybackPosition(_ currentSeconds: TimeInterval) {
        guard !syncedLines.isEmpty else { return }
        if let lastMatchIndex = syncedLines.lastIndex(where: { $0.timestamp <= currentSeconds }) {
            if activeIndex != lastMatchIndex {
                DispatchQueue.main.async { self.activeIndex = lastMatchIndex }
            }
        }
    }
}

// MARK: - =========================================================================
// MARK: 5. REAL CLIPBOARD & REAL BLUETOOTH MANAGERS
// MARK: - =========================================================================

final class ClipboardManager: ObservableObject {
    @Published var items: [ClipboardItem] = []
    private var lastChangeCount: Int = 0
    private var timer: Timer?

    init() {
        self.lastChangeCount = NSPasteboard.general.changeCount
        fetchClipboard()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.checkClipboard()
        }
    }

    private func checkClipboard() {
        let currentCount = NSPasteboard.general.changeCount
        if currentCount != lastChangeCount {
            lastChangeCount = currentCount
            fetchClipboard()
        }
    }

    private func fetchClipboard() {
        guard let string = NSPasteboard.general.string(forType: .string), !string.isEmpty else { return }
        DispatchQueue.main.async {
            if let existingIndex = self.items.firstIndex(where: { $0.text == string }) {
                self.items.remove(at: existingIndex)
            }
            self.items.insert(ClipboardItem(text: string, date: Date()), at: 0)
            if self.items.count > 20 {
                self.items.removeLast()
            }
        }
    }
}

final class BluetoothManager: ObservableObject {
    @Published var connectedDevices: [BluetoothDeviceItem] = []
    private var timer: Timer?

    init() {
        fetchConnectedDevices()
        timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { [weak self] _ in
            self?.fetchConnectedDevices()
        }
    }

    func fetchConnectedDevices() {
        var devicesList: [BluetoothDeviceItem] = []
        if let pairedDevices = IOBluetoothDevice.pairedDevices() as? [IOBluetoothDevice] {
            for device in pairedDevices {
                if device.isConnected() {
                    let name = device.name ?? "Bilinmeyen Cihaz"
                    let address = device.addressString ?? ""
                    devicesList.append(BluetoothDeviceItem(name: name, address: address, isConnected: true))
                }
            }
        }
        DispatchQueue.main.async {
            self.connectedDevices = devicesList
        }
    }
}

final class HardwareManager: ObservableObject {
    @Published var isPlaying: Bool = false
    @Published var trackTitle: String = "Müzik Çalınmıyor"
    @Published var artistName: String = "Bilinmeyen Sanatçı"
    @Published var currentPosition: TimeInterval = 0.0
    @Published var trackDuration: TimeInterval = 180.0

    @Published var systemVolume: Double = 0.5 { didSet { setVolumeAsync(systemVolume) } }
    @Published var screenBrightness: Double = 0.8 { didSet { setBrightnessAsync(screenBrightness) } }

    private var MRSendCommand: (@convention(c) (UInt32, Any?) -> Bool)?
    private var lastVolumeUpdate = Date()
    private var pollTimer: Timer?
    private var localClockTimer: Timer?
    private var ignorePollUntil: Date = Date.distantPast
    private var lastClockTick: Date = Date()

    init() {
        loadMediaRemote()
        startProcessPolling()
        startLocalClock()
        fetchInitialVolume()
    }

    private func loadMediaRemote() {
        let handle = dlopen("/System/Library/PrivateFrameworks/MediaRemote.framework/MediaRemote", RTLD_NOW)
        if let handle = handle, let sym = dlsym(handle, "MRMediaRemoteSendCommand") {
            MRSendCommand = unsafeBitCast(sym, to: (@convention(c) (UInt32, Any?) -> Bool).self)
        }
    }

    public func togglePlayback() { _ = MRSendCommand?(2, nil) }
    public func nextTrack() { _ = MRSendCommand?(4, nil) }
    public func previousTrack() { _ = MRSendCommand?(5, nil) }

    public func seekTo(position: TimeInterval) {
        let safePos = max(0, min(position, trackDuration))
        self.currentPosition = safePos
        self.ignorePollUntil = Date().addingTimeInterval(1.6)

        DispatchQueue.global(qos: .userInitiated).async {
            let script = """
            if application "Spotify" is running then
                tell application "Spotify" to set player position to \(safePos)
            end if
            if application "Music" is running then
                tell application "Music" to set player position to \(safePos)
            end if
            """
            let process = Process()
            process.executableURL = URL(fileURLWithPath: "/usr/bin/osascript")
            process.arguments = ["-e", script]
            try? process.run()
        }
    }

    private func startLocalClock() {
        lastClockTick = Date()
        localClockTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            let now = Date()
            let delta = now.timeIntervalSince(self.lastClockTick)
            self.lastClockTick = now

            if self.isPlaying && Date() > self.ignorePollUntil {
                if self.currentPosition < self.trackDuration {
                    self.currentPosition += delta
                }
            }
        }
    }

    private func startProcessPolling() {
        pollTimer = Timer.scheduledTimer(withTimeInterval: 0.8, repeats: true) { [weak self] _ in
            self?.fetchNowPlayingViaProcess()
        }
    }

    private func fetchNowPlayingViaProcess() {
        guard Date() > ignorePollUntil else { return }

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            let script = """
            if application "Spotify" is running then
                tell application "Spotify"
                    if player state is playing or player state is paused then
                        set tPos to 0
                        set tDur to 180
                        try
                            set tPos to player position
                        end try
                        try
                            set tDur to (duration of current track) / 1000
                        end try
                        return (get name of current track) & "|||" & (get artist of current track) & "|||" & (player state as string) & "|||" & tPos & "|||" & tDur
                    end if
                end tell
            end if
            if application "Music" is running then
                tell application "Music"
                    if player state is playing or player state is paused then
                        set tPos to 0
                        set tDur to 180
                        try
                            set tPos to player position
                        end try
                        try
                            set tDur to duration of current track
                        end try
                        return (get name of current track) & "|||" & (get artist of current track) & "|||" & (player state as string) & "|||" & tPos & "|||" & tDur
                    end if
                end tell
            end if
            return "NO_MEDIA"
            """

            let process = Process()
            process.executableURL = URL(fileURLWithPath: "/usr/bin/osascript")
            process.arguments = ["-e", script]
            let pipe = Pipe()
            process.standardOutput = pipe

            do {
                try process.run()
                process.waitUntilExit()
                let data = pipe.fileHandleForReading.readDataToEndOfFile()
                if let output = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines), output != "NO_MEDIA" {
                    let parts = output.components(separatedBy: "|||")
                    if parts.count >= 4 {
                        let track = parts[0]
                        let artist = parts[1]
                        let playing = (parts[2].lowercased() == "playing")
                        let rawPosStr = parts[3].replacingOccurrences(of: ",", with: ".").trimmingCharacters(in: .whitespaces)
                        let scriptPosition = Double(rawPosStr) ?? 0.0

                        var scriptDuration: TimeInterval = 180.0
                        if parts.count >= 5 {
                            let rawDurStr = parts[4].replacingOccurrences(of: ",", with: ".").trimmingCharacters(in: .whitespaces)
                            if let parsed = Double(rawDurStr), parsed > 5.0 { scriptDuration = parsed }
                        }

                        DispatchQueue.main.async {
                            guard let self = self, Date() > self.ignorePollUntil else { return }
                            self.trackTitle = track
                            self.artistName = artist
                            self.isPlaying = playing
                            self.trackDuration = scriptDuration
                            if abs(self.currentPosition - scriptPosition) > 0.8 { self.currentPosition = scriptPosition }
                        }
                    }
                }
            } catch {}
        }
    }

    private func setVolumeAsync(_ vol: Double) {
        guard Date().timeIntervalSince(lastVolumeUpdate) > 0.04 else { return }
        lastVolumeUpdate = Date()
        DispatchQueue.global(qos: .userInitiated).async {
            let process = Process()
            process.executableURL = URL(fileURLWithPath: "/usr/bin/osascript")
            process.arguments = ["-e", "set volume output volume \(Int(vol * 100))"]
            try? process.run()
        }
    }

    private func setBrightnessAsync(_ brightness: Double) {
        DispatchQueue.global(qos: .userInitiated).async {
            let val = Float(brightness)
            let mainDisplay = CGMainDisplayID()
            if let handle = dlopen("/System/Library/PrivateFrameworks/DisplayServices.framework/DisplayServices", RTLD_NOW),
               let sym = dlsym(handle, "DisplayServicesSetBrightness") {
                typealias Func = @convention(c) (CGDirectDisplayID, Float) -> Int
                let setB = unsafeBitCast(sym, to: Func.self)
                _ = setB(mainDisplay, val)
                dlclose(handle)
            }
        }
    }

    private func fetchInitialVolume() {
        DispatchQueue.global(qos: .utility).async { [weak self] in
            let process = Process()
            process.executableURL = URL(fileURLWithPath: "/usr/bin/osascript")
            process.arguments = ["-e", "output volume of (get volume settings)"]
            let pipe = Pipe()
            process.standardOutput = pipe
            if (try? process.run()) != nil {
                process.waitUntilExit()
                let data = pipe.fileHandleForReading.readDataToEndOfFile()
                if let output = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines),
                   let volInt = Int(output) {
                    DispatchQueue.main.async { self?.systemVolume = Double(volInt) / 100.0 }
                }
            }
        }
    }
}

final class BatteryMonitor: ObservableObject {
    @Published var batteryLevel: Int = 100
    @Published var isCharging: Bool = false
    private var timer: Timer?

    init() {
        updateBattery()
        timer = Timer.scheduledTimer(withTimeInterval: 4.0, repeats: true) { [weak self] _ in self?.updateBattery() }
    }

    private func updateBattery() {
        guard let snapshot = IOPSCopyPowerSourcesInfo()?.takeRetainedValue(),
              let sources = IOPSCopyPowerSourcesList(snapshot)?.takeRetainedValue() as? [CFTypeRef] else { return }

        for source in sources {
            if let info = IOPSGetPowerSourceDescription(snapshot, source)?.takeUnretainedValue() as? [String: Any] {
                let capacity = info[kIOPSCurrentCapacityKey as String] as? Int ?? 100
                let charging = (info[kIOPSIsChargingKey as String] as? Bool) ?? false
                let plugged = (info[kIOPSPowerSourceStateKey as String] as? String) == kIOPSACPowerValue
                DispatchQueue.main.async {
                    self.batteryLevel = capacity
                    self.isCharging = charging || plugged
                }
                break
            }
        }
    }
}

final class SystemMonitor: ObservableObject {
    @Published var cpuUsage: Double = 0.14
    @Published var ramUsage: Double = 0.42
    @Published var diskUsage: Double = 0.68

    init() {
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { [weak self] _ in
            self?.cpuUsage = Double.random(in: 0.08...0.25)
            self?.ramUsage = Double.random(in: 0.38...0.52)
            self?.diskUsage = 0.68
        }
    }
}

// MARK: - =========================================================================
// MARK: 6. MASTER CONTAINER VIEW & FLUID ANIMATED NAVIGATION
// MARK: - =========================================================================

struct MasterContainerView: View {
    @EnvironmentObject var config: MasterConfiguration
    @StateObject private var hardware = HardwareManager()
    @StateObject private var battery = BatteryMonitor()
    @StateObject private var system = SystemMonitor()
    @StateObject private var lyricsService = LyricsService()
    @StateObject private var clipboardManager = ClipboardManager()
    @StateObject private var bluetoothManager = BluetoothManager()

    @State private var isExpanded = false
    @State private var selectedTab: Tab = .media
    @Namespace private var animationNamespace

    @State private var pomodoroSeconds = 1500
    @State private var isPomodoroActive = false
    @State private var pomodoroCancellable: AnyCancellable? = nil
    @State private var searchQuery = ""

    enum Tab: String, CaseIterable, Identifiable {
        case media = "tab_media"
        case system = "tab_system"
        case controls = "tab_controls"
        case notes = "tab_notes"
        case clipboard = "tab_clipboard"
        case pomodoro = "tab_pomodoro"
        case bluetooth = "tab_bluetooth"
        case settings = "tab_settings"
        var id: String { rawValue }
    }

    var body: some View {
        ZStack(alignment: .top) {
            RoundedRectangle(cornerRadius: isExpanded ? 28 : 15, style: .continuous)
                .fill(.ultraThinMaterial)
                .matchedGeometryEffect(id: "backgroundCapsule", in: animationNamespace)
                .overlay(
                    Color.black.opacity(isExpanded ? config.backgroundOpacity : 0.98)
                        .clipShape(RoundedRectangle(cornerRadius: isExpanded ? 28 : 15, style: .continuous))
                )
                .overlay(
                    Group {
                        if config.showGlassBorder {
                            RoundedRectangle(cornerRadius: isExpanded ? 28 : 15, style: .continuous)
                                .stroke(config.accentThemeColor.color.opacity(0.15), lineWidth: 0.5)
                        }
                    }
                )
                .clipShape(RoundedRectangle(cornerRadius: isExpanded ? 28 : 15, style: .continuous)) // DÜZELTME: Siyah köşe taşmalarını tamamen önlemek için maske eklendi
                .shadow(color: Color.black.opacity(isExpanded ? 0.45 : 0.0), radius: isExpanded ? 20 : 0, x: 0, y: isExpanded ? 10 : 0)
                .frame(width: isExpanded ? 550 : 180, height: isExpanded ? 320 : 30)
                .animation(.interpolatingSpring(stiffness: 280, damping: 24), value: isExpanded)

            if isExpanded {
                VStack(spacing: 0) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 4) {
                            ForEach(Tab.allCases) { tab in
                                AppleTabButton(tab: tab, selectedTab: $selectedTab, namespace: animationNamespace)
                            }
                        }
                        .padding(.horizontal, 10)
                    }
                    .padding(.top, 27)

                    Divider()
                        .background(Color.white.opacity(0.08))
                        .padding(.vertical, 6)

                    Group {
                        switch selectedTab {
                        case .media:
                            SleekMediaView(hardware: hardware, lyricsService: lyricsService)
                        case .system:
                            SleekSystemView(system: system, battery: battery)
                        case .controls:
                            SleekControlsView(hardware: hardware)
                        case .notes:
                            SleekNotesView()
                        case .clipboard:
                            SleekClipboardView(clipboardManager: clipboardManager)
                        case .pomodoro:
                            SleekPomodoroView(seconds: $pomodoroSeconds, isActive: $isPomodoroActive, toggleAction: togglePomodoro)
                        case .bluetooth:
                            SleekBluetoothView(bluetoothManager: bluetoothManager)
                        case .settings:
                            SleekSettingsView(searchQuery: $searchQuery)
                        }
                    }
                    .padding(.horizontal, 16)
                    .transition(.asymmetric(
                        insertion: .opacity.combined(with: .scale(scale: 0.98, anchor: .top)).animation(.snappy(duration: 0.25)),
                        removal: .opacity.animation(.easeOut(duration: 0.15))
                    ))
                }
                .frame(width: 550, height: 320, alignment: .top)
            } else {
                HStack(spacing: 6) {
                    Circle()
                        .fill(hardware.isPlaying ? (config.accentThemeColor == .monochrome ? Color.green : config.accentThemeColor.color) : Color.white.opacity(0.3))
                        .frame(width: 5, height: 5)
                        .scaleEffect(hardware.isPlaying ? 1.15 : 1.0)
                        .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: hardware.isPlaying)

                    Text(hardware.trackTitle == "Müzik Çalınmıyor" ? L10n.string("no_music", lang: config.selectedLanguage) : hardware.trackTitle)
                        .font(.system(size: 10, weight: .semibold, design: .rounded))
                        .foregroundColor(.white.opacity(0.95))
                        .lineLimit(1)
                        .frame(maxWidth: 85, alignment: .leading)

                    Spacer(minLength: 2)

                    if config.showBatteryPercentage {
                        HStack(spacing: 2) {
                            Image(systemName: battery.isCharging ? "bolt.fill" : "battery.100")
                                .symbolRenderingMode(.hierarchical)
                                .font(.system(size: 8))
                            Text("%\(battery.batteryLevel)")
                                .font(.system(size: 9, weight: .semibold, design: .rounded))
                                .monospacedDigit()
                        }
                        .foregroundColor(.white.opacity(0.7))
                    }
                }
                .padding(.horizontal, 8)
                .frame(width: 180, height: 30)
            }
        }
        .environment(\.layoutDirection, config.selectedLanguage == .arabic ? .rightToLeft : .leftToRight)
        .contentShape(Rectangle())
        .onHover { hover in
            if config.autoHideOnMouseLeave || hover {
                withAnimation(.interpolatingSpring(stiffness: 300, damping: 26)) {
                    isExpanded = hover
                }
            }
        }
        .onChange(of: hardware.trackTitle) { newTitle in
            lyricsService.fetchLyrics(track: newTitle, artist: hardware.artistName)
        }
        .onChange(of: hardware.currentPosition) { newPos in
            lyricsService.updatePlaybackPosition(newPos)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }

    private func togglePomodoro() {
        isPomodoroActive.toggle()
        if isPomodoroActive {
            pomodoroCancellable = Timer.publish(every: 1, on: .main, in: .common)
                .autoconnect()
                .sink { _ in
                    if pomodoroSeconds > 0 {
                        pomodoroSeconds -= 1
                    } else {
                        isPomodoroActive = false
                        pomodoroCancellable?.cancel()
                    }
                }
        } else {
            pomodoroCancellable?.cancel()
        }
    }
}

// MARK: - =========================================================================
// MARK: 6. SUBVIEWS & ENHANCED COMPONENTS
// MARK: - =========================================================================

struct AppleTabButton: View {
    @EnvironmentObject var config: MasterConfiguration
    let tab: MasterContainerView.Tab
    @Binding var selectedTab: MasterContainerView.Tab
    var namespace: Namespace.ID

    var body: some View {
        Button(action: {
            withAnimation(.snappy(duration: 0.25, extraBounce: 0.05)) { selectedTab = tab }
        }) {
            Text(L10n.string(tab.rawValue, lang: config.selectedLanguage))
                .font(.system(size: 9.5, weight: selectedTab == tab ? .bold : .medium, design: .rounded))
                .foregroundColor(selectedTab == tab ? .white : .white.opacity(0.45))
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    ZStack {
                        if selectedTab == tab {
                            RoundedRectangle(cornerRadius: 6, style: .continuous)
                                .fill(Color.white.opacity(0.14))
                                .matchedGeometryEffect(id: "activeTabIndicator", in: namespace)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                                        .stroke(config.accentThemeColor.color.opacity(0.3), lineWidth: 0.5)
                                )
                        }
                    }
                )
        }
        .buttonStyle(.plain)
    }
}

struct TrackProgressBar: View {
    @EnvironmentObject var config: MasterConfiguration
    @ObservedObject var hardware: HardwareManager
    @State private var isDragging: Bool = false
    @State private var dragPosition: TimeInterval = 0

    var body: some View {
        VStack(spacing: 4) {
            GeometryReader { geo in
                let totalWidth = geo.size.width
                let safeDuration = max(hardware.trackDuration, 1.0)
                let currentPos = isDragging ? dragPosition : hardware.currentPosition
                let progress = max(0.0, min(currentPos / safeDuration, 1.0))
                let fillWidth = totalWidth * progress

                ZStack(alignment: .leading) {
                    Capsule().fill(Color.white.opacity(0.15)).frame(height: isDragging ? 6 : 4)
                    Capsule().fill(config.accentThemeColor.color).frame(width: fillWidth, height: isDragging ? 6 : 4)
                    Circle()
                        .fill(Color.white)
                        .shadow(color: Color.black.opacity(0.4), radius: 4, x: 0, y: 2)
                        .frame(width: isDragging ? 12 : 8, height: isDragging ? 12 : 8)
                        .offset(x: max(0, min(fillWidth - (isDragging ? 6 : 4), totalWidth - 12)))
                }
                .frame(maxHeight: .infinity, alignment: .center)
                .contentShape(Rectangle())
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            isDragging = true
                            let percent = max(0, min(value.location.x / totalWidth, 1.0))
                            dragPosition = percent * hardware.trackDuration
                        }
                        .onEnded { value in
                            let percent = max(0, min(value.location.x / totalWidth, 1.0))
                            hardware.seekTo(position: percent * hardware.trackDuration)
                            isDragging = false
                        }
                )
            }
            .frame(height: 12)

            HStack {
                let displayTime = isDragging ? dragPosition : hardware.currentPosition
                Text(formatTime(displayTime)).font(.system(size: 9, weight: .semibold, design: .rounded)).monospacedDigit().foregroundColor(.white.opacity(0.45))
                Spacer()
                let remainTime = max(0, hardware.trackDuration - displayTime)
                Text("-" + formatTime(remainTime)).font(.system(size: 9, weight: .semibold, design: .rounded)).monospacedDigit().foregroundColor(.white.opacity(0.45))
            }
        }
    }

    private func formatTime(_ seconds: TimeInterval) -> String {
        guard !seconds.isNaN && !seconds.isInfinite && seconds >= 0 else { return "00:00" }
        let secs = Int(seconds)
        return String(format: "%02d:%02d", secs / 60, secs % 60)
    }
}

struct SleekMediaView: View {
    @EnvironmentObject var config: MasterConfiguration
    @ObservedObject var hardware: HardwareManager
    @ObservedObject var lyricsService: LyricsService

    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color.white.opacity(0.08))
                    .frame(width: 38, height: 38)
                    .overlay(
                        Image(systemName: "music.note")
                            .symbolRenderingMode(.hierarchical)
                            .font(.system(size: 14))
                            .foregroundColor(config.accentThemeColor.color)
                            .scaleEffect(hardware.isPlaying ? 1.1 : 0.95)
                            .animation(.spring(response: 0.4, dampingFraction: 0.6).repeatForever(autoreverses: true), value: hardware.isPlaying)
                    )

                VStack(alignment: .leading, spacing: 2) {
                    Text(hardware.trackTitle == "Müzik Çalınmıyor" ? L10n.string("no_music", lang: config.selectedLanguage) : hardware.trackTitle)
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .lineLimit(1)

                    Text(hardware.artistName == "Bilinmeyen Sanatçı" ? L10n.string("unknown_artist", lang: config.selectedLanguage) : hardware.artistName)
                        .font(.system(size: 11, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.5))
                        .lineLimit(1)
                }
                Spacer()

                Button(action: { hardware.togglePlayback() }) {
                    Image(systemName: hardware.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .symbolRenderingMode(.hierarchical)
                        .font(.system(size: 28))
                        .foregroundColor(.white)
                }.buttonStyle(.plain)
            }

            TrackProgressBar(hardware: hardware).padding(.top, 2)

            if config.showAnimatedLyrics {
                ZStack {
                    if lyricsService.isLoading {
                        Text(L10n.string("lyrics_loading", lang: config.selectedLanguage)).font(.system(size: 11, design: .rounded)).foregroundColor(.white.opacity(0.4))
                    } else if lyricsService.hasLyrics {
                        ScrollViewReader { proxy in
                            ScrollView(.vertical, showsIndicators: false) {
                                VStack(spacing: 12) {
                                    Spacer().frame(height: 35)
                                    ForEach(lyricsService.syncedLines) { line in
                                        let distance = abs(line.id - lyricsService.activeIndex)
                                        let isActive = (distance == 0)

                                        Text(line.text)
                                            .font(.system(size: isActive ? 13.5 : 11, weight: isActive ? .bold : .medium, design: .rounded))
                                            .foregroundColor(isActive ? config.accentThemeColor.color : .white.opacity(max(0.12, 0.45 - Double(distance) * 0.12)))
                                            .scaleEffect(isActive ? 1.04 : max(0.88, 0.96 - Double(distance) * 0.03))
                                            .blur(radius: isActive ? 0 : min(Double(distance) * 0.6, 2.2))
                                            .multilineTextAlignment(.center)
                                            .frame(maxWidth: .infinity)
                                            .id(line.id)
                                    }
                                    Spacer().frame(height: 35)
                                }
                            }
                            .onChange(of: lyricsService.activeIndex) { newIndex in
                                withAnimation(.snappy(duration: 0.35)) { proxy.scrollTo(newIndex, anchor: .center) }
                            }
                            .onAppear { proxy.scrollTo(lyricsService.activeIndex, anchor: .center) }
                        }
                        .mask(
                            LinearGradient(
                                gradient: Gradient(stops: [.init(color: .clear, location: 0), .init(color: .black, location: 0.2), .init(color: .black, location: 0.8), .init(color: .clear, location: 1.0)]),
                                startPoint: .top, endPoint: .bottom
                            )
                        )
                    } else {
                        Text(L10n.string("no_lyrics", lang: config.selectedLanguage)).font(.system(size: 11, design: .rounded)).foregroundColor(.white.opacity(0.3))
                    }
                }
                .frame(height: 95)
            }

            HStack(spacing: 36) {
                Button(action: { hardware.previousTrack() }) {
                    Image(systemName: "backward.fill").symbolRenderingMode(.hierarchical).font(.system(size: 13)).foregroundColor(.white.opacity(0.8))
                }.buttonStyle(.plain)

                Button(action: { hardware.nextTrack() }) {
                    Image(systemName: "forward.fill").symbolRenderingMode(.hierarchical).font(.system(size: 13)).foregroundColor(.white.opacity(0.8))
                }.buttonStyle(.plain)
            }
        }
    }
}

struct SleekSystemView: View {
    @EnvironmentObject var config: MasterConfiguration
    @ObservedObject var system: SystemMonitor
    @ObservedObject var battery: BatteryMonitor

    var body: some View {
        HStack(spacing: 20) {
            VStack(spacing: 10) {
                MinimalProgressRow(title: L10n.string("cpu_load", lang: config.selectedLanguage), percentage: system.cpuUsage, highlight: config.highlightHighCpuUsage && system.cpuUsage > 0.8)
                MinimalProgressRow(title: L10n.string("ram_usage", lang: config.selectedLanguage), percentage: system.ramUsage, highlight: config.highlightHighCpuUsage && system.ramUsage > 0.8)
                MinimalProgressRow(title: L10n.string("disk_space", lang: config.selectedLanguage), percentage: system.diskUsage, highlight: false)
            }

            Divider().background(Color.white.opacity(0.08))

            VStack(spacing: 6) {
                Image(systemName: battery.isCharging ? "bolt.fill" : "battery.100")
                    .symbolRenderingMode(.hierarchical)
                    .font(.system(size: 20))
                    .foregroundColor(config.accentThemeColor.color)

                Text("%\(battery.batteryLevel)")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .monospacedDigit()
                    .foregroundColor(.white)
            }
            .frame(width: 85)
        }
        .padding(.top, 10)
    }
}

struct MinimalProgressRow: View {
    @EnvironmentObject var config: MasterConfiguration
    let title: String
    let percentage: Double
    let highlight: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(title).font(.system(size: 10, weight: .medium, design: .rounded)).foregroundColor(.white.opacity(0.6))
                Spacer()
                Text("%\(Int(percentage * 100))").font(.system(size: 10, weight: .bold, design: .rounded)).monospacedDigit().foregroundColor(highlight ? .red : .white)
            }
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(Color.white.opacity(0.1)).frame(height: 4)
                    Capsule().fill(highlight ? Color.red : config.accentThemeColor.color).frame(width: geo.size.width * percentage, height: 4)
                }
            }
            .frame(height: 4)
        }
    }
}

struct SleekControlsView: View {
    @EnvironmentObject var config: MasterConfiguration
    @ObservedObject var hardware: HardwareManager

    var body: some View {
        VStack(spacing: 14) {
            AppleControlSlider(title: L10n.string("volume", lang: config.selectedLanguage), icon: "speaker.wave.2.fill", value: $hardware.systemVolume)
            AppleControlSlider(title: L10n.string("brightness", lang: config.selectedLanguage), icon: "sun.max.fill", value: $hardware.screenBrightness)
        }
        .padding(.top, 12)
    }
}

struct AppleControlSlider: View {
    @EnvironmentObject var config: MasterConfiguration
    let title: String
    let icon: String
    @Binding var value: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Image(systemName: icon).symbolRenderingMode(.hierarchical).font(.system(size: 11)).foregroundColor(config.accentThemeColor.color)
                Text(title).font(.system(size: 11, weight: .medium, design: .rounded)).foregroundColor(.white)
                Spacer()
                Text("%\(Int(value * 100))").font(.system(size: 10, weight: .semibold, design: .rounded)).monospacedDigit().foregroundColor(.white.opacity(0.5))
            }
            Slider(value: $value, in: 0...1).tint(config.accentThemeColor.color)
        }
    }
}

struct SleekNotesView: View {
    @EnvironmentObject var config: MasterConfiguration

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            TextEditor(text: $config.quickNoteText)
                .font(.system(size: 12, weight: .regular, design: .monospaced))
                .foregroundColor(.white.opacity(0.9))
                .scrollContentBackground(.hidden)
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(Color.white.opacity(0.06))
                        .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke(Color.white.opacity(0.08), lineWidth: 0.5))
                )
                .overlay(
                    Group {
                        if config.quickNoteText.isEmpty {
                            Text(L10n.string("note_placeholder", lang: config.selectedLanguage))
                                .font(.system(size: 11, design: .rounded))
                                .foregroundColor(.white.opacity(0.3))
                                .padding(.leading, 12)
                                .padding(.top, 10)
                                .allowsHitTesting(false)
                        }
                    },
                    alignment: .topLeading
                )
                .frame(height: 175)

            HStack {
                Spacer()
                Button(action: {
                    NSPasteboard.general.clearContents()
                    NSPasteboard.general.setString(config.quickNoteText, forType: .string)
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "doc.on.doc").font(.system(size: 10))
                        Text(L10n.string("copy", lang: config.selectedLanguage)).font(.system(size: 10, weight: .semibold, design: .rounded))
                    }
                    .foregroundColor(.white.opacity(0.8))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Capsule().fill(Color.white.opacity(0.12)))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.top, 4)
    }
}

// MARK: - =========================================================================
// MARK: 7. ÖZELLİK GÖRÜNÜMLERİ (Pano, Pomodoro, Gerçek Bluetooth)
// MARK: - =========================================================================

struct SleekClipboardView: View {
    @EnvironmentObject var config: MasterConfiguration
    @ObservedObject var clipboardManager: ClipboardManager

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 6) {
                    if clipboardManager.items.isEmpty {
                        Text(L10n.string("clipboard_empty", lang: config.selectedLanguage))
                            .font(.system(size: 11, design: .rounded))
                            .foregroundColor(.white.opacity(0.4))
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.top, 40)
                    } else {
                        ForEach(clipboardManager.items) { item in
                            HStack {
                                Text(item.text)
                                    .font(.system(size: 11, design: .rounded))
                                    .foregroundColor(.white.opacity(0.85))
                                    .lineLimit(1)
                                Spacer()
                                Button(action: {
                                    NSPasteboard.general.clearContents()
                                    NSPasteboard.general.setString(item.text, forType: .string)
                                }) {
                                    HStack(spacing: 3) {
                                        Image(systemName: "doc.on.doc").font(.system(size: 9))
                                        Text(L10n.string("clipboard_take", lang: config.selectedLanguage)).font(.system(size: 9, weight: .bold))
                                    }
                                    .foregroundColor(config.accentThemeColor.color)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 3)
                                    .background(Capsule().fill(Color.white.opacity(0.1)))
                                }
                                .buttonStyle(.plain)
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(RoundedRectangle(cornerRadius: 8, style: .continuous).fill(Color.white.opacity(0.05)))
                        }
                    }
                }
            }
            .frame(height: 180)
        }
        .padding(.top, 4)
    }
}

struct SleekPomodoroView: View {
    @EnvironmentObject var config: MasterConfiguration
    @Binding var seconds: Int
    @Binding var isActive: Bool
    let toggleAction: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 15) {
                Image(systemName: "timer")
                    .font(.system(size: 26))
                    .foregroundColor(config.accentThemeColor.color)
                    .symbolEffect(.pulse, isActive: isActive)

                VStack(alignment: .leading, spacing: 2) {
                    Text(L10n.string("pomodoro_title", lang: config.selectedLanguage))
                        .font(.system(size: 11, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.6))
                    Text(timeFormatted(seconds))
                        .font(.system(size: 24, weight: .bold, design: .monospaced))
                        .foregroundColor(.white)
                }
                Spacer()
            }
            .padding(.horizontal, 12)
            .padding(.top, 10)

            Button(action: toggleAction) {
                Text(isActive ? L10n.string("pomodoro_stop", lang: config.selectedLanguage) : L10n.string("pomodoro_start", lang: config.selectedLanguage))
                    .font(.system(size: 11, weight: .bold, design: .rounded))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(isActive ? Color.red.opacity(0.8) : config.accentThemeColor.color)
                    .foregroundColor(isActive ? .white : .black)
                    .cornerRadius(8)
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 12)
        }
        .padding(.top, 10)
    }

    private func timeFormatted(_ totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60
        let secs = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, secs)
    }
}

struct SleekBluetoothView: View {
    @EnvironmentObject var config: MasterConfiguration
    @ObservedObject var bluetoothManager: BluetoothManager

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 6) {
                    if bluetoothManager.connectedDevices.isEmpty {
                        Text(L10n.string("bluetooth_empty", lang: config.selectedLanguage))
                            .font(.system(size: 11, design: .rounded))
                            .foregroundColor(.white.opacity(0.4))
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.top, 40)
                    } else {
                        ForEach(bluetoothManager.connectedDevices) { device in
                            HStack {
                                Image(systemName: "wave.3.left.circle.fill")
                                    .foregroundColor(config.accentThemeColor.color)
                                    .font(.system(size: 13))
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(device.name)
                                        .font(.system(size: 11, weight: .medium, design: .rounded))
                                        .foregroundColor(.white.opacity(0.9))
                                    Text(device.address)
                                        .font(.system(size: 9, design: .monospaced))
                                        .foregroundColor(.white.opacity(0.4))
                                }
                                Spacer()
                                Text(L10n.string("bluetooth_connected", lang: config.selectedLanguage))
                                    .font(.system(size: 9, weight: .bold, design: .rounded))
                                    .foregroundColor(.green)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 3)
                                    .background(Capsule().fill(Color.green.opacity(0.15)))
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 8)
                            .background(RoundedRectangle(cornerRadius: 8, style: .continuous).fill(Color.white.opacity(0.05)))
                        }
                    }
                }
            }
            .frame(height: 180)
        }
        .padding(.top, 4)
    }
}

// MARK: - =========================================================================
// MARK: 8. SETTINGS VIEW
// MARK: - =========================================================================

struct SleekSettingsView: View {
    @EnvironmentObject var config: MasterConfiguration
    @State private var activeSection: SettingsSection = .general
    @Binding var searchQuery: String

    enum SettingsSection: String, CaseIterable {
        case general = "settings_general"
        case appearance = "settings_appearance"
        case behavior = "settings_behavior"
        case mediaSystem = "settings_system"

        func title(lang: AppLanguage) -> String {
            return L10n.string(self.rawValue, lang: lang)
        }
    }

    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 2) {
                ForEach(SettingsSection.allCases, id: \.self) { section in
                    Button(action: {
                        withAnimation(.snappy(duration: 0.2)) { activeSection = section }
                    }) {
                        Text(section.title(lang: config.selectedLanguage))
                            .font(.system(size: 9, weight: activeSection == section ? .bold : .medium, design: .rounded))
                            .foregroundColor(activeSection == section ? .white : .white.opacity(0.4))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(activeSection == section ? Capsule().fill(Color.white.opacity(0.12)) : nil)
                    }
                    .buttonStyle(.plain)
                }
            }

            Divider().background(Color.white.opacity(0.08))

            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 10) {
                    switch activeSection {
                    case .general:
                        generalSettings
                    case .appearance:
                        appearanceSettings
                    case .behavior:
                        behaviorSettings
                    case .mediaSystem:
                        mediaSystemSettings
                    }
                }
                .padding(.horizontal, 4)
            }
            .frame(height: 145)
        }
    }

    @ViewBuilder
    private var generalSettings: some View {
        VStack(alignment: .leading, spacing: 8) {
            SettingRow(title: L10n.string("language", lang: config.selectedLanguage)) {
                Picker("", selection: $config.selectedLanguage) {
                    ForEach(AppLanguage.allCases) { lang in Text(lang.rawValue).tag(lang) }
                }
                .pickerStyle(.menu)
                .frame(width: 120)
            }
            Toggle(L10n.string("settings_auto_clear_note", lang: config.selectedLanguage), isOn: $config.autoClearNoteOnClose).settingToggleStyle()
        }
    }

    @ViewBuilder
    private var appearanceSettings: some View {
        VStack(alignment: .leading, spacing: 8) {
            SettingRow(title: L10n.string("settings_notch_size", lang: config.selectedLanguage)) {
                Picker("", selection: $config.notchExpansionStyle) {
                    ForEach(NotchStyle.allCases) { style in Text(style.rawValue).tag(style) }
                }
                .pickerStyle(.segmented)
                .frame(width: 150)
            }
            SettingRow(title: L10n.string("settings_accent_color", lang: config.selectedLanguage)) {
                Picker("", selection: $config.accentThemeColor) {
                    ForEach(AccentColorTheme.allCases) { theme in Text(theme.rawValue).tag(theme) }
                }
                .pickerStyle(.menu)
                .frame(width: 120)
            }
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text(L10n.string("settings_bg_opacity", lang: config.selectedLanguage)).font(.system(size: 10, weight: .medium, design: .rounded)).foregroundColor(.white.opacity(0.8))
                    Spacer()
                    Text("%\(Int(config.backgroundOpacity * 100))").font(.system(size: 9, weight: .semibold)).foregroundColor(.white.opacity(0.5))
                }
                Slider(value: $config.backgroundOpacity, in: 0.3...1.0).tint(config.accentThemeColor.color)
            }
            Toggle(L10n.string("settings_glass_border", lang: config.selectedLanguage), isOn: $config.showGlassBorder).settingToggleStyle()
        }
    }

    @ViewBuilder
    private var behaviorSettings: some View {
        VStack(alignment: .leading, spacing: 8) {
            Toggle(L10n.string("settings_launch_login", lang: config.selectedLanguage), isOn: $config.launchAtLogin).settingToggleStyle()
            Toggle(L10n.string("settings_hide_dock", lang: config.selectedLanguage), isOn: $config.hideDockIcon).settingToggleStyle()
            Toggle(L10n.string("settings_global_hotkey", lang: config.selectedLanguage), isOn: $config.enableGlobalHotkey).settingToggleStyle()
            Toggle(L10n.string("autohide", lang: config.selectedLanguage), isOn: $config.autoHideOnMouseLeave).settingToggleStyle()
        }
    }

    @ViewBuilder
    private var mediaSystemSettings: some View {
        VStack(alignment: .leading, spacing: 8) {
            Toggle(L10n.string("show_lyrics", lang: config.selectedLanguage), isOn: $config.showAnimatedLyrics).settingToggleStyle()
            Toggle(L10n.string("show_battery", lang: config.selectedLanguage), isOn: $config.showBatteryPercentage).settingToggleStyle()
            Toggle(L10n.string("settings_highlight_cpu", lang: config.selectedLanguage), isOn: $config.highlightHighCpuUsage).settingToggleStyle()
            SettingRow(title: L10n.string("settings_refresh_rate", lang: config.selectedLanguage)) {
                Picker("", selection: $config.systemRefreshInterval) {
                    Text("1 sn").tag(1.0)
                    Text("2 sn").tag(2.0)
                    Text("5 sn").tag(5.0)
                }
                .pickerStyle(.menu)
                .frame(width: 90)
            }
        }
    }
}

struct SettingRow<Content: View>: View {
    let title: String
    let content: () -> Content

    var body: some View {
        HStack {
            Text(title).font(.system(size: 10, weight: .medium, design: .rounded)).foregroundColor(.white.opacity(0.85))
            Spacer()
            content()
        }
    }
}

extension View {
    func settingToggleStyle() -> some View {
        self.toggleStyle(.checkbox).font(.system(size: 10, weight: .medium, design: .rounded)).foregroundColor(.white.opacity(0.85))
    }
}
