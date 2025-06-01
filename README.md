# Hafiyyat


<div align = center >
  <img src = 'https://github.com/user-attachments/assets/7640bdcc-b2fc-4a0c-b7b2-10a8221c98f5' width=50% >
</div>

## 📌 Proje Tanımı

Hafiyyat, steganografi tekniğini kullanarak görüntülerin içerisine gizli veri yerleştirmeyi amaçlayan bir mobil uygulamadır. Flutter ile geliştirilen bu proje, kullanıcıların bir görüntüyü başka bir görüntüye görünmez bir şekilde yerleştirerek güvenli veri aktarımı ve saklamasını mümkün kılar.


Uygulama temel olarak LSB (Least Significant Bit) yöntemiyle çalışır. LSB yöntemi düşük düzeyde sağlamlık sunsa da, Hafiyyat’ta bu zayıflık bir şifreleme katmanı ile desteklenmiş ve gizli verinin kırılganlığı azaltılmıştır.


İlk sürümlerde yalnızca gri tonlamalı görüntüler desteklenirken, son versiyonlarda sıkıştırma ve şifreleme tekniklerinin eklenmesiyle birlikte artık renkli bir görüntünün, başka bir renkli görüntünün içine gömülmesi mümkün hâle gelmiştir. Hafiyyat bu yönüyle, hem eğitimsel bir örnek hem de temel düzeyde güvenli veri saklama amacı taşıyan pratik bir araçtır.


## 🎬 Uygulama Tanıtım Videosu

[![Hafiyyat Kullanım Videosu](https://github.com/user-attachments/assets/26fbd9a8-f047-4f64-b605-1dfbbe565d74)](https://youtu.be/92ibbBdBu1U?si=DHxsW89ki2gAXukP)



## 🎯 Özellikler

**🔒 Görünmez Güvenlik:**
Hafiyyat, steganografi ve şifreleme tekniklerini bir araya getirerek görüntülerin içine fark edilmeyecek şekilde veri gizler. Böylece bilgilerin yalnızca yetkili kişiler tarafından erişilebilmesini sağlar.

**🔑 Görünür Güvenlik:**
Hafiyyat, steganografi alanında büyük bir güvenlik sağlayan isteğe bağlı kullanıcılardan alınan özel bir anahtar kullanarak gizleme işleminde alınır ve çıkartma işleminde aynı anahtarı kullanılması gerektiği için sadece gizleyen çıkartabilir. eğer kullanıcı kullanmamayı tercih ederse algoritma otomatik olarak **melazgirt** kelimesini anahtar olarak kullanılıyor, çıkartmada da boş bıraktığı zaman aynı kelime kebul edeilir, böylece sadece **Hafiyyat** uygulamasını kullanarak çıkartmayı sağlar.

**🖼️ Renkli Görüntü Desteği:**
Başlangıçta yalnızca gri tonlamalı görsellerin gizlenmesi mümkünken, geliştirilen sıkıştırma algoritması sayesinde artık **renkli fotoğraflar başka renkli fotoğrafların içine başarıyla entegre edilebilmektedir**.

**📱 Mobil Uyumlu ve Hafif:**
Uygulama, tamamen mobil cihazlar düşünülerek Flutter ile geliştirilmiştir. Hızlı, sade ve kullanıcı dostu bir arayüze sahiptir; düşük donanımlı cihazlarda bile sorunsuz çalışır.

**🔐 Şifreleme ile Güçlendirilmiş Dayanıklılık:**
LSB (Least Significant Bit) yönteminin doğasında bulunan kırılganlık, entegre şifreleme katmanı sayesinde güçlendirilmiştir. Böylece veri güvenliği yalnızca gizleme katmanına değil, aynı zamanda matematiksel korumaya da dayanır.

**📂 Çoklu Sürüm Desteği:**
Hafiyyat, her sürümde yeni özellikler ve iyileştirmelerle gelişen bir projedir. Versiyonlar açıkça ayrılmıştır ve her biri farklı ihtiyaçlara göre optimize edilmiştir.

**🚀 Kolay Kullanım:**
Gizleme ve çıkarma işlemlerinin her biri ayrı tuş olarak tasarlanmıştır, kullanıcıların teknik bilgiye ihtiyaç duymadan uygulamayı etkin bir şekilde kullanmalarını sağlar.

<div align = center >
  <img src = 'https://github.com/user-attachments/assets/ac671139-9e84-43df-8b15-060223bd46be'>
</div>

## 🖼️ Görüntü Gizleme Süreci

**Hafiyyat** uygulamasında bir görüntünün başka bir görüntüye güvenli ve gizli bir şekilde gömülmesi, aşağıdaki adımlar doğrultusunda gerçekleştirilir:

#### 1. **Cover (Kaplayıcı) Görüntünün Seçilmesi**
   Kullanıcıdan, hedef görüntüyü gizleyeceği renkli bir "kaplayıcı" görüntü (cover image) seçmesi istenir. Bu görüntü, dışarıdan bakıldığında sadece normal bir fotoğraf gibi görünür.

#### 2. **Gizlenecek Görüntünün (Host) Alınması**
   Ardından, kullanıcıdan içine gömülecek olan ikinci bir renkli görüntü seçmesi istenir. Bu görüntü, steganografi ve şifreleme işlemlerine tabi tutulacaktır.

#### 3. **Özel Anahtar İsteği (İsteğe Bağlı)**
   Kullanıcıya, işlemi daha güvenli hale getirmek için isteğe bağlı olarak özel bir anahtar (custom key) eklemek isteyip istemediği sorulur.

   * Eğer bir özel anahtar girilirse, bu anahtar daha sonra çıkarma (decryption) işlemi sırasında **zorunlu** olacaktır.
   * Kullanıcı özel bir anahtar girmezse, sistem otomatik olarak "melazgirt" kelimesini varsayılan anahtar olarak kullanır. Bu sayede, yalnızca Hafiyyat uygulamasına özgü algoritma ile veri çözülebilir; farklı bir yöntemle gizlenen içeriğe erişilmesi mümkün olmaz.

#### 4. **Host Görüntünün PNG Formatında Sıkıştırılması**
   Gizlenecek görüntü, kayıpsız bir sıkıştırma yöntemi olan PNG formatında encode edilerek boyutu küçültülür. Bu işlem, görüntünün gizleneceği alanı daha verimli kullanabilmek adına önemlidir.

#### 5. Özel anahtar, SHA-256 algoritmasıyla hashlenir.
   Özel anahtar asla doğrudan görüntünün içine gömülmez. Çünkü gizlenecek veriyi korumak için bu anahtar kullanılır. Gömülseydi, şifre çözülmeden görüntüye ulaşmak mümkün olurdu. Bunun yerine, anahtardan türetilen değerler (örneğin AES anahtarı ve IV) şifreleme ve deşifreleme işlemlerinde kullanılır.
   * İlk 16 bayt → AES-GCM için IV (Initialization Vector) olarak kullanılır.
   * Tüm 32 bayt (256 bit) → AES algoritması için şifreleme anahtarı (Key) olur.

#### 6. **AES-GCM Algoritmasıyla Şifreleme**
   Eğer kullanıcı özel bir anahtar girmişse, PNG ile sıkıştırılmış host görüntü, AES algoritmasının Galois/Counter Mode (GCM) kullanılarak şifrelenir.

   * Anahtar ve IV (Initialization Vector), kullanıcının özel anahtarından SHA-256 ile türetilir.
   * Bu adım, görüntünün yalnızca şifre çözme anahtarına sahip kişiler tarafından geri alınabilmesini sağlar.

#### 7. **Gizli Görüntünün LSB ile Gömülmesi**
   Son adımda, şifrelenmiş (veya sadece sıkıştırılmış) host görüntü, Cover görüntünün piksellerine **LSB (Least Significant Bit)** yöntemiyle gömülür.

   * Bu yöntem, görünür kaliteyi bozmadan veriyi saklamaya olanak tanır.
   * Her bir pikselin kırmızı, yeşil ve mavi bileşenlerinin en düşük anlamlı bitleri, gizli görüntüye ait verilerle değiştirilir.

Bir hata oluştuğunda veya veri bütünlüğünün bozulması durumunda, sistem kullanıcıyı hata mesajı ile bilgilendirir.


<div align = center >
  <img src = 'https://github.com/user-attachments/assets/f5cd0148-f30e-4630-b3f1-d0c2cd7695c5'>
</div>


## 🖼️ Görüntü Çıkarma Süreci

**Hafiyyat** uygulamasında, daha önce gizlenmiş bir görüntünün güvenli ve başarılı bir şekilde geri çıkarılması şu adımlarla gerçekleştirilir:

#### 1. Stego Görüntünün Seçilmesi

Kullanıcıdan, içerisinde gizli bir görüntü barındıran **Stego Görüntü**yü (önceden işlenmiş ve veriyi barındıran görsel) seçmesi istenir. Bu görüntü dışarıdan bakıldığında sıradan bir fotoğraf gibi görünür; ancak içinde şifreli veri taşır.

#### 2. Özel Anahtarın Girilmesi

Gizleme aşamasında kullanıcı özel bir anahtar belirlediyse, çıkarma işleminin yapılabilmesi için aynı anahtarın tekrar girilmesi gerekir.

* Eğer kullanıcı anahtar girmezse, sistem otomatik olarak `"melazgirt"` kelimesini varsayılan anahtar olarak kullanır.
* Bu yaklaşım, sadece **Hafiyyat** uygulamasıyla uyumlu çıkartma işlemini mümkün kılar; dış müdahaleleri önler.

#### 3. Anahtarın SHA-256 ile Hashlenmesi

Girilen anahtar doğrudan kullanılmaz. Bunun yerine:

* **SHA-256** algoritması ile 256 bit uzunluğunda bir hash’e dönüştürülür.
* Bu hash:

  * İlk 16 baytı → AES-GCM algoritmasında **IV (Initialization Vector)** olarak,
  * Tamamı → AES şifreleme için **Key (Anahtar)** olarak kullanılır.

Bu yapı, hem şifre çözme güvenliğini artırır hem de istikrar sağlar.

#### 4. Stego Görüntüden LSB ile Verinin Çözülmesi

Stego görüntüdeki piksellerin en düşük anlamlı bitleri (LSB), sırayla okunarak gömülü veri elde edilir.

* Bu işlem sonucunda, şifrelenmiş ve sıkıştırılmış **host görüntü**nün bayt dizisi ortaya çıkarılır.

#### 5. AES-GCM ile Şifreyi Çözme

Elde edilen veri, özel anahtar ile şifrelenmişse:

* SHA-256'dan türetilmiş **Key** ve **IV** kullanılarak,
* **AES-GCM** algoritmasıyla deşifre edilir.

Bu adımda, yalnızca doğru anahtarı giren kullanıcılar veriye erişebilir.

### 6. Host Görüntünün Yeniden Oluşturulması

Şifre çözme işlemi başarıyla tamamlandıktan sonra, ortaya çıkan veri henüz ham hâlidir ve doğrudan bir görüntü olarak yorumlanamaz.
Bu yüzden:

* Şifrelenmeden önce uygulanan **PNG sıkıştırması**, bu aşamada **decode (çözme)** işlemine tabi tutulur.
* Bu işlem sayesinde, sıkıştırılmış veriler tekrar anlamlı piksel bilgilerine dönüştürülerek orijinal renkli **host görüntü** eksiksiz şekilde geri elde edilir.

Bu adım sonunda, kullanıcı gizli görüntüyü görüntüleyebilir ya da cihazına kaydedebilir.

Yanlış anahtar girilmesi veya veri bütünlüğünün bozulması durumunda, sistem kullanıcıyı hata mesajı ile bilgilendirir.

<div align = center >
  <img src = 'https://github.com/user-attachments/assets/999a9015-2a27-4f1d-9d9d-4779b34541b3'>
</div>


## 🛠️ Teknik Bilgi

Bu bölümde, Hafiyyat uygulamasının altyapısını oluşturan teknik bileşenler, kullanılan teknolojiler ve mimari kararlar hakkında kapsamlı bir açıklama yer almaktadır. Uygulamanın temel amacı, gizlencek görüntüleri güvenli bir şekilde renkli görüntülerin içine gizlemek ve bu işlemi şifreleme ile entegre biçimde gerçekleştirmektir. Projede özellikle veri güvenliği, gizlilik ve mobilde performans ilkeleri göz önünde bulundurulmuştur.


### 📦 Kullanılan Paketler ve Görevleri

Uygulama geliştirirken, her bir işlevi modüler ve sürdürülebilir hale getirmek amacıyla çeşitli açık kaynak Flutter paketlerinden faydalanılmıştır:

* **`encrypt`**: AES algoritmasını kullanarak verileri şifrelemek ve şifre çözmek için kullanılır. GCM (Galois/Counter Mode) modu tercih edilmiştir çünkü hem şifreleme hem de mesaj bütünlüğü sağlar.
* **`crypto`**: Kullanıcıdan alınan anahtarı SHA256 algoritmasıyla özetleyerek 256-bit uzunlukta sabit bir anahtar ve IV (Initialization Vector) üretmek için kullanılır. Böylece, aynı anahtar her zaman aynı çıktıyı üretir, bu da çözümleme işlemi için gereklidir.
* **`image`**: Görüntüleri piksel düzeyinde işlemek için kullanılır.
* **`image_picker`**: Kullanıcının galeriden ya da kameradan görüntü seçmesine olanak tanır.
* **`media_store_plus`**: Android cihazlarda oluşturulan görüntülerin doğrudan galeriye kaydedilmesini sağlar.
* **`archive`**: Görsellerin ya da gömülü verilerin sıkıştırılarak daha verimli şekilde saklanması için kullanılır.
* **`path_provider`**: Uygulamanın cihaz dosya sisteminde geçici ve kalıcı dizinlere erişimini sağlar.
* **`permission_handler`**: Dosya sistemi ve galeri gibi bileşenlere erişmek için gerekli izinleri yönetir.
* **`shared_preferences`**: Kullanıcı tercihleri, ayarlar ve küçük boyutlu kalıcı verileri saklamak için kullanılır.
* **`share_plus`**: Uygulama içinde dosya ve görsel paylaşımı için kullanılır.
* **`async`, `vector_math`, `material_color_utilities`**: Performans, renk işlemleri ve arka plan hesaplamalarını daha verimli hale getirmek için destekleyici roller üstlenir.


### 🔍 Steganografi Katmanı

Uygulamanın kalbinde, renkli (RGB) bir hedef görüntü içine başka bir renkli görüntünün piksellerinin düşük anlamlı bitlerine (Least Significant Bit - LSB) gömülmesi yer alır. Bu teknik sayesinde kullanıcılar, örneğin bir belge ya da gizli bir ekran görüntüsünü, herhangi bir masum görselin içinde saklayabilir.

* **LSB Steganografi**: Her bir pikselin kırmızı, yeşil ve mavi bileşenlerinin en düşük anlamlı bitleri, gizlenecek görüntünün pikselleriyle değiştirilir. Bu işlem sırasında görünür kaliteyi fark edilir şekilde bozmamak için özel matematiksel dengelemeler uygulanır.
* **Renk Desteği**: Yeni sürümde artık gri tonlamalı değil, tam renkli (24-bit RGB) görüntüler arasında gizleme işlemi yapılabilmektedir. Bu sayede görsel kayıplar minimize edilir ve steganaliz saldırılarına karşı daha dirençli bir yapı sunulur.


### 🔐 Şifreleme Katmanı

Gömülecek görüntü, steganografi işleminden önce AES-GCM (Advanced Encryption Standard - Galois/Counter Mode) algoritmasıyla şifrelenir. Bu, hem veri bütünlüğünü korur hem de ek bir güvenlik katmanı sağlar.

* **Anahtar Türetilmesi**: Kullanıcının girdiği özel anahtar (customKey), SHA-256 algoritmasıyla 256-bit uzunluğunda bir şifreleme anahtarına dönüştürülür. Aynı anahtardan deterministik bir Initialization Vector (IV) de türetilir.
* **AES-GCM Modu**: Modern bir simetrik şifreleme yöntemi olan GCM, şifreleme ile birlikte mesaj doğrulama kodu da üretir. Bu da, verinin değiştirilip değiştirilmediğinin denetlenmesini sağlar.


### ⚙️ Performans ve Paralel İşleme

Şifreleme ve deşifreleme işlemleri, `compute` fonksiyonu aracılığıyla izole işlemlerde (isolate) yürütülür. Bu sayede uygulamanın arayüzü işlem sırasında beklemeyi belirten ikonlar ve yazılar gösterirken uygulama donmaz ve kullanıcı deneyimi sorunsuz şekilde devam eder.


### 🎨 Steganografi (Görsel Gizleme) İşlemi

Gizleme işlemi temelde aşağıdaki adımlarla gerçekleştirilir:

1. Kullanıcıdan alınan gizlenecek görüntü, `image` paketi ile analiz edilir.
2. Renkli hedef görüntü üzerinde seçilen RGB kanallarına, gizlenecek görüntüdeki veri bit düzeyinde gömülür.
3. Bu işlem sonucunda kullanıcıya göre fark edilmeyecek düzeyde bir bozulma meydana gelir; çünkü gömülen veriler genellikle alt bitlerde saklanır (örneğin LSB - Least Significant Bit).
4. Çözümleme işlemi tersine gerçekleştirilir. Renkli görüntüdeki belirli bitler okunarak orijinal gizlenen görüntü geri elde edilir.
5. Şayet şifreleme aktifleştirilmişse, çözümleme öncesinde AES anahtar kullanılarak verinin şifresi çözülür.

### 📁 Dosya Sistemi ve İzin Yönetimi

Mobil uygulamalarda dosya erişimi kullanıcı gizliliği açısından önemlidir. Bu nedenle Hafiyyat aşağıdaki politikaları takip eder:

* **Android 10 ve üzeri** sistemlerde Scoped Storage kurallarına uyumlu çalışmak için `media_store_plus` paketi tercih edilmiştir.
* Görsel oluşturma, okuma ve yazma işlemleri `path_provider` ile `TemporaryDirectory` ve `ApplicationDocumentsDirectory` üzerinde gerçekleştirilir.
* Kullanıcıdan galeriye erişim izni alınmadan herhangi bir dosya işlemi yapılmaz. Bu izinler `permission_handler` ile yönetilir.
* Gömülü ya da şifrelenmiş görsellerin paylaşımı `share_plus` paketi ile yapılır.


### 🧪 Test ve Hata Takibi

Kodun güvenilirliğini artırmak ve beklenmedik hataları erkenden yakalayabilmek için aşağıdaki test araçları ve stratejileri uygulanmıştır:

* `flutter_test`, `flutter_lints`: Standart widget ve birim testleri yazılarak güvenlik ve kararlılık sağlanır.
* `leak_tracker`, `leak_tracker_flutter_testing`: Bellek sızıntılarını tespit etmek ve optimize etmek için kullanılır.
* `fake_async`, `vm_service`: Zaman bağımlı senaryoları test etmek ve uygulamanın çalışma zamanında sistem kaynaklarını nasıl kullandığını analiz etmek için kullanılır.


# 📦 Versiyonlar

Tüm anlamlı değişikliklerin listesi aşağıda sıralanmıştır. Bu proje, [Semantik Sürümleme](https://semver.org/lang/tr/) kurallarını takip eder.

---

## [v1.3.1](https://github.com/yasir237/hafiyyat/releases/tag/v1.3.1) – UI Donma Sorunları Giderildi
> 🗓️ Geliştirme Tarihi: 2025-05-28

- Şifreleme ve çıkarma işlemlerinde kullanılan iş parçacıkları (threads) yeniden düzenlendi.
- Ana iş parçacığında yürütülen işlemler nedeniyle yaşanan **arayüz donmaları giderildi**.
- Uygulama artık daha akıcı ve kullanıcı dostu.

📲 **Denemek ister misin?**

Android cihazına uygulamayı indirip deneyebilirsin:
👉 [hafiyyat-v1.3.1.apk](https://github.com/yasir237/Hafiyyat/releases/download/v1.3.1/app-release.apk)

> *Not: APK’yı yüklemeden önce “bilinmeyen kaynaklara izin ver” ayarını etkinleştirmen gerekebilir.*

---

## [v1.3.0](https://github.com/yasir237/hafiyyat/releases/tag/v1.3.0) – Kullanıcı Anahtarı Desteği
> 🗓️ Geliştirme Tarihi: 2025-05-20

- Şifreleme işlemi için artık **kullanıcıdan özel bir anahtar alınabiliyor.**
- Girilen anahtar SHA-256 ile hashlenip AES-GCM şifrelemesi için kullanılmakta.
- Bu özellik, verinin yalnızca anahtarı bilen kişiler tarafından erişilebilir olmasını sağlar.

---

## [v1.2.0](https://github.com/yasir237/hafiyyat/releases/tag/v1.2.0) – Renkli Görüntü & Sıkıştırma
> 🗓️ Geliştirme Tarihi: 2025-05-14

- Gizlenecek görseller artık **renkli (RGB)** formatta destekleniyor.
- Veriler, **PNG formatında kayıpsız sıkıştırma** ile daha küçük boyutlarda saklanabiliyor.
- Bu güncellemeyle birlikte daha büyük verilerin gömülmesi mümkün hale geldi.

---

## [v1.1.0](https://github.com/yasir237/hafiyyat/releases/tag/v1.1.0) – Şifreleme Eklendi
> 🗓️ Geliştirme Tarihi: 2025-05-10

- Steganografik veriler artık **AES-GCM algoritmasıyla şifrelenebiliyor.**
- Veri güvenliği için temel adım atıldı.

---

## [v1.0.0](https://github.com/yasir237/hafiyyat/releases/tag/v1.0.0) – İlk Kararlı Sürüm
> 🗓️ Geliştirme Tarihi: 2025-05-05

- **Hafiyyat**’ın ilk çalışabilir versiyonu yayınlandı.
- Gri tonlamalı bir görsel, başka bir görselin içine gizlenebiliyor.
- Şifreleme veya veri koruma mekanizmaları henüz bulunmuyordu.
- Bu sürüm, temel steganografi mantığının sade bir prototipi olarak geliştirildi.



# 📄 Lisans

Bu proje [MIT Lisansı](LICENSE) ile lisanslanmıştır.

Hafiyyat uygulamasını kullanmakta özgürsünüz, ancak bu uygulamayı kullanan kişilerin aşağıdaki şartları kabul ettiği varsayılır:

- Orijinal yazarı belirtmelidirler.
- Herhangi bir garanti verilmez; uygulama "olduğu gibi" sunulmaktadır.
- Kodun değiştirilmiş versiyonları dağıtılabilir, ancak aynı lisans ile.

Detaylı bilgi için lütfen `LICENSE` dosyasına göz atın.



