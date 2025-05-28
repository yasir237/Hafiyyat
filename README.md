# Hafiyyat

## 📌 Proje Tanımı

Hafiyyat, steganografi tekniğini kullanarak görüntülerin içerisine gizli veri yerleştirmeyi amaçlayan bir mobil uygulamadır. Flutter ile geliştirilen bu proje, kullanıcıların bir görüntüyü başka bir görüntüye görünmez bir şekilde yerleştirerek güvenli veri aktarımı ve saklamasını mümkün kılar.


Uygulama temel olarak LSB (Least Significant Bit) yöntemiyle çalışır. LSB yöntemi düşük düzeyde sağlamlık sunsa da, Hafiyyat’ta bu zayıflık bir şifreleme katmanı ile desteklenmiş ve gizli verinin kırılganlığı azaltılmıştır.


İlk sürümlerde yalnızca gri tonlamalı görüntüler desteklenirken, son versiyonlarda sıkıştırma ve şifreleme tekniklerinin eklenmesiyle birlikte artık renkli bir görüntünün, başka bir renkli görüntünün içine gömülmesi mümkün hâle gelmiştir. Hafiyyat bu yönüyle, hem eğitimsel bir örnek hem de temel düzeyde güvenli veri saklama amacı taşıyan pratik bir araçtır.


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



