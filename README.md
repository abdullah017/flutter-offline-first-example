

# Flutter: Offline-First Todo Uygulaması (Riverpod & Isar)

![Flutter](https://img.shields.io/badge/Flutter-3.x-blue?logo=flutter)
![License](https://img.shields.io/badge/License-MIT-green)
![Architecture](https://img.shields.io/badge/Architecture-Offline--First-orange)
![State Management](https://img.shields.io/badge/State%20Management-Riverpod-blueviolet)
![Database](https://img.shields.io/badge/Database-Isar-purple)

Bu proje, Flutter ile modern, ölçeklenebilir ve **"Offline-First"** bir uygulama geliştirmek için kapsamlı bir örnek sunmaktadır. Uygulama, **Riverpod** state yönetimi, **Isar** yerel veritabanı ve **Feature-First** klasör yapısı gibi güncel ve en iyi pratikleri (best practices) temel alır.

## İçindekiler

- [Öne Çıkan Konseptler](#öne-çıkan-konseptler)
- [Kullanılan Teknolojiler](#kullanılan-teknolojiler-tech-stack)
- [Proje Yapısı (Feature-First)](#proje-yapısı-feature-first)
- [Kurulum ve Başlatma](#kurulum-ve-başlatma)
- [Uygulama Akışı ve Test Senaryoları](#uygulama-akışı-ve-test-senaryoları)
- [Mimari Üzerine Detaylı Makale](#mimari-üzerine-detaylı-makale)
- [Lisans](#lisans)

## Öne Çıkan Konseptler

Bu projenin mimarisi dört ana sütun üzerine inşa edilmiştir:

1.  **Offline-First:** Uygulama, birincil veri kaynağı olarak cihazın yerel deposunu kullanır. Bu sayede internet bağlantısı olmadığında bile tam fonksiyonel çalışır ve kullanıcıya kesintisiz, hızlı bir deneyim sunar.
2.  **Feature-First Mimarisi:** Kodlar, ait oldukları özelliklere göre gruplanır (`features/todos`, `features/auth` vb.). Bu yapı, projenin modüler, ölçeklenebilir ve bakımı kolay olmasını sağlar.
3.  **Riverpod ile Reaktif State Yönetimi:** Compile-time güvenliği, basitliği ve gücü ile öne çıkan Riverpod, özellikle `AsyncNotifier` kullanarak asenkron veri akışlarını (yükleniyor, veri, hata) yönetmeyi son derece kolaylaştırır.
4.  **Repository Deseni:** UI katmanını veri kaynaklarının karmaşıklığından (yerel veya uzak) soyutlar. Bu sayede uygulamanın test edilebilirliği ve esnekliği artar.

## Kullanılan Teknolojiler (Tech Stack)

| Kategori              | Paket                                                                    | Açıklama                                                                |
| --------------------- | ------------------------------------------------------------------------ | ----------------------------------------------------------------------- |
| **State Management**  | `flutter_riverpod` / `riverpod_generator`                                | Modern, compile-safe ve reaktif state yönetimi.                         |
| **Local Database**    | `isar` / `isar_flutter_libs`                                             | Flutter için tasarlanmış, nesne tabanlı ve süper hızlı NoSQL veritabanı. |
| **Immutable Models**  | `freezed`                                                                | Değişmez (immutable) veri sınıfları ve `copyWith` gibi yardımcılar için. |
| **API Client**        | `dio`                                                                    | Güçlü ve popüler HTTP istemcisi.                                        |
| **Connection Check**  | `connectivity_plus`                                                      | Cihazın ağ bağlantı durumunu kontrol etmek için.                        |
| **File System**       | `path_provider`                                                          | Isar veritabanını saklamak için platforma özel dosya yolunu bulur.      |
| **Code Generation**   | `build_runner`                                                           | `freezed`, `riverpod_generator` ve `isar` için kod üretimi yapar.         |

## Proje Yapısı (Feature-First)

```
lib/
├── core/
│   ├── database/
│   │   └── isar_service.dart      # Isar'ı başlatan ve yöneten servis
│   ├── providers/
│   │   └── app_providers.dart     # Genel (core) provider'lar (Isar, Dio vb.)
│   └── main.dart                  # Uygulamanın başlangıç noktası
│
└── features/
    └── todos/
        ├── data/
        │   ├── datasources/
        │   │   ├── todo_local_datasource.dart
        │   │   └── todo_remote_datasource.dart # Sahte API
        │   ├── models/
        │   │   └── todo_model.dart             # Isar ile uyumlu model
        │   └── repositories/
        │       └── todo_repository_impl.dart   # Repository implementasyonu
        ├── domain/
        │   ├── entities/
        │   │   └── todo.dart                   # Saf UI/Domain nesnesi
        │   └── repositories/
        │       └── todo_repository.dart        # Repository arayüzü
        └── presentation/
            ├── providers/
            │   └── todo_providers.dart         # "Todos" feature'ına özel provider'lar
            ├── screens/
            │   └── todos_screen.dart
            └── widgets/
                ├── add_todo_dialog.dart
                └── todo_list_item.dart
```

## Kurulum ve Başlatma

Projeyi yerel makinenizde çalıştırmak için aşağıdaki adımları izleyin.

1.  **Projeyi Klonlayın**

    ```bash
    git clone https://github.com/KULLANICI_ADINIZ/flutter_offline_first_exam.git
    cd flutter_offline_first_exam
    ```

2.  **Bağımlılıkları Yükleyin**

    ```bash
    flutter pub get
    ```

3.  **Kod Üreticisini Çalıştırın**
    Bu adım, `freezed`, `riverpod_generator` ve `isar` için gerekli olan `*.g.dart` ve `*.freezed.dart` dosyalarını oluşturur. Bu dosyalar olmadan proje çalışmayacaktır.

    ```bash
    flutter pub run build_runner build --delete-conflicting-outputs
    ```

4.  **Uygulamayı Çalıştırın**

    ```bash
    flutter run
    ```

## Uygulama Akışı ve Test Senaryoları

Bu uygulamanın offline-first yeteneklerini test etmek için aşağıdaki senaryoları deneyebilirsiniz.

#### Bölüm 1: Çevrimiçi (Online) Deneyim

1.  **Uygulamayı Açın:** İnternetiniz açıkken uygulamayı başlatın. Kısa bir yükleme sonrası 3 maddelik bir görev listesi görmelisiniz.
2.  **İşlemler Yapın:** Yeni görev ekleyin, mevcut bir görevi tamamlayın veya silin. Tüm işlemlerin anında gerçekleştiğini gözlemleyin.

#### Bölüm 2: Çevrimdışı (Offline) Deneyim

1.  **İnterneti Kapatın:** Telefonunuzu **Uçak Modu'na** alın.
2.  **Uygulamayı Kapatıp Açın:** Uygulamayı tamamen kapatıp tekrar açtığınızda, listenin **yükleme animasyonu olmadan** anında geldiğini göreceksiniz.
3.  **Çevrimdışı İşlem Yapın:** Yeni bir görev ekleyin. Görevin anında listeye eklendiğini ve yanında bir **senkronizasyon ikonu (🔄)** belirdiğini fark edin. Bu, verinin yerelde kaydedildiğini ama sunucuya gönderilmeyi beklediğini gösterir.

#### Bölüm 3: Yeniden Çevrimiçi Olma ve Senkronizasyon

1.  **İnterneti Açın:** Uçak Modu'nu kapatın.
2.  **Listeyi Yenileyin:** Uygulamanın sağ üstündeki yenileme butonuna (🔃) basın.
3.  **Sonucu Gözlemleyin:** Kısa bir yükleme sonrası, çevrimdışıyken eklediğiniz görevin yanındaki **senkronizasyon ikonunun (🔄) kaybolduğunu** göreceksiniz. Bu, beklemedeki tüm değişikliklerin başarıyla sunucuya iletildiğini gösterir.

---

## Mimari Üzerine Detaylı Makale

### Flutter'da Zirve Performans: Riverpod ve Isar ile Kurşun Geçirmez Offline-First Mimarisi

Mobil uygulama kullanıcıları artık kesintisiz bir deneyim bekliyor. Metroda, uçakta veya internetin zayıf olduğu bir bölgede, uygulamanızın "İnternet bağlantısı yok" hatası verip işlevsiz kalması kabul edilemez. İşte bu noktada "Offline-First" mimarisi devreye giriyor. Bu makalede, Flutter'da **Riverpod** state yönetimi, **Isar** yerel veritabanı ve **Feature-First** klasör yapısını kullanarak nasıl modern, ölçeklenebilir ve sağlam bir offline-first uygulama inşa edebileceğinizi adım adım inceleyeceğiz.

#### Offline-First Nedir ve Neden Önemlidir?

Offline-first, bir uygulamanın birincil veri kaynağının uzak bir sunucu değil, cihazın kendi yerel deposu olduğu bir geliştirme yaklaşımıdır. Uygulama, internet bağlantısı olup olmadığını umursamadan çalışır.

**Avantajları:**
-   **Harika Kullanıcı Deneyimi (UX):** Veriler yerelden okunduğu için arayüz anında tepki verir. Yükleme ekranları ve gecikmeler minimuma iner.
-   **Güvenilirlik:** Uygulama, ağ koşullarından bağımsız olarak her zaman çalışır.
-   **Pil Tasarrufu:** Sürekli ağ isteği yapmak yerine, sadece gerektiğinde senkronizasyon yapılır.

#### Mimarinin Çalışma Prensibi: Repository Deseni

Uygulamamızın beyni, **Repository** katmanıdır. Bu katman, uygulamanın geri kalanından veri kaynaklarının (yerel mi, uzak mı) karmaşıklığını soyutlar.

**Veri Okuma Akışı (`getTodos`):**
1.  Uygulama, `TodosNotifier`'dan verileri ister.
2.  `TodosNotifier`, `TodoRepository`'den verileri talep eder.
3.  `TodoRepository`, internet bağlantısını kontrol eder.
    -   **EĞER İNTERNET VARSA:**
        -   Uzak API'den en güncel verileri çekmeye çalışır.
        -   Başarılı olursa, bu yeni verileri Isar'a kaydederek yerel depoyu günceller.
        -   Çektiği taze veriyi `Notifier`'a döndürür.
        -   Eğer uzak API'den veri çekerken bir hata oluşursa, kullanıcıyı mağdur etmemek için Isar'daki son bilinen veriyi döndürür.
    -   **EĞER İNTERNET YOKSA:**
        -   Hiç beklemeden doğrudan Isar'daki verileri okur ve `Notifier`'a döndürür.

**Veri Yazma Akışı (`addTodo`):**
1.  Kullanıcı yeni bir "Todo" ekler. UI, `TodosNotifier`'daki `addTodo` metodunu çağırır.
2.  **Optimistic UI:** `Notifier`, API veya veritabanı yanıtını beklemeden, yeni "Todo"yu mevcut state listesine ekleyerek arayüzü **anında** günceller. Bu, kullanıcıya uygulamanın yıldırım hızında çalıştığı hissini verir.
3.  `Notifier`, `TodoRepository`'deki `addTodo` metodunu çağırır.
4.  `Repository`, yeni "Todo"yu **önce Isar'a** kaydeder. Bu, verinin her koşulda güvende olmasını sağlar.
5.  Ardından, internet bağlantısı varsa, veriyi uzak API'ye göndermeyi dener. Başarısız olursa, veri zaten yerelde kayıtlı olduğu için hiçbir veri kaybı yaşanmaz.

#### Sonuç

Bu mimari; **Riverpod**'un reaktif gücü, **Isar**'ın yerel depolama hızı ve **Feature-First** yapısının organizasyonel yeteneklerini birleştirerek Flutter ile hem geliştirici hem de kullanıcı dostu uygulamalar oluşturmanın yolunu gösteriyor. Offline-first sadece bir teknik değil, kullanıcıya saygı duyan bir felsefedir.

## Lisans

Bu proje [MIT Lisansı](LICENSE) altında lisanslanmıştır.
