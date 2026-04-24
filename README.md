# APP_NEWS
# 📰 News App — Flutter

Aplikasi berita berbasis Flutter yang mengambil data dari **GNews API** dengan arsitektur modular, caching offline, dan error handling yang lengkap.

---

## 📁 Struktur Folder
lib/
├── models/
│   └── article_model.dart       # Definisi struktur data artikel
├── services/
│   ├── news_service.dart        # Logika pemanggilan GNews API
│   └── cache_service.dart       # Penyimpanan & pembacaan cache lokal
├── providers/
│   └── news_provider.dart       # State management & logika bisnis
└── views/
├── home/
│   └── home_view.dart       # Halaman utama (list berita, search, filter)
├── detail/
│   └── detail_view.dart     # Halaman detail artikel
└── widgets/
├── article_card.dart    # Reusable widget kartu artikel
├── shimmer_card.dart    # Reusable widget loading shimmer
└── error_widget.dart    # Reusable widget tampilan error

---

## 🧠 Alasan Memilih Provider
saya memilih **Provider** karena beberapa alasan:

**1. Sesuai skala project**
Provider cukup untuk mengelola state di aplikasi berita ini. BLoC dan Riverpod lebih cocok untuk aplikasi besar dengan banyak fitur kompleks — menggunakannya di sini justru menambah boilerplate yang tidak perlu.

**2. Terintegrasi langsung dengan Flutter**
Provider adalah solusi resmi yang direkomendasikan oleh tim Flutter untuk state management tingkat menengah. Tidak memerlukan dependensi eksternal yang berat.

**3. Mudah dipahami dan di-debug**
Dengan `ChangeNotifier`, perubahan state mudah dilacak. Cukup panggil `notifyListeners()` dan semua widget yang mendengarkan akan otomatis diperbarui.

**4. Fleksibel untuk pengembangan ke depan**
Karena UI hanya bergantung pada getter yang ada di Provider, implementasi internal bisa diganti ke BLoC atau Riverpod di kemudian hari tanpa perlu mengubah satu pun file di `views/`.


## 🔌 API

Aplikasi menggunakan **GNews API** ([gnews.io](https://gnews.io)).

Endpoint yang digunakan:
- `GET /top-headlines` — Mengambil berita utama per kategori
- `GET /search` — Mencari berita berdasarkan keyword

---

## 📦 Dependencies Utama

| Package | Kegunaan |
|---|---|
| `provider` | State management |
| `http` | HTTP request ke API |
| `shared_preferences` | Caching data offline per kategori |
| `shimmer` | Efek loading shimmer |
| `connectivity_plus` | Deteksi status koneksi internet |

---

## ✨ Fitur

- Berita dari 6 kategori: Technology, Business, Science, Health, Sports, Entertainment
- Search real-time dengan debounce 400ms
- Filter kategori dengan chip
- Shimmer effect saat loading
- Cache offline per kategori (valid 1 jam)
- Fallback otomatis ke cache jika API gagal
- Error UI yang ramah pengguna
