Bu dizin temelde sitemizin HTML içeriğini oluşturmak için tasarlanmıştır.

Önemli dosyalar:

<dl>
<dt><tt>belgeler.xml</tt></dt>
<dd>Belgelerimizi oluşturan XML ağacının kökünü içerir.</dd>
  
<dt><tt>validate</tt></dt>
<dd>XML ve DTD doğrulamaları yapmak için kullanılır.</dd>

<dt><tt>scripts/id-ile-derle.sh</tt></dt>
<dd>HTML belge üretimi içindir. Bu betik ile sitenin tamamı derlenebildiği
gibi, belge ağacındaki tek bir dosyayı bile üretmek mümkündür.
Derlenecek XML dosyasının xml:id'si komut satırından belirtilirse
o XML dosyanın içerdiği ağaçtan HTML belge(leri)/yi üretir.
(HTML dosya isimleri xml:id'lerden türetilmektedir.)</dd>

<dt><tt>manpages/xml2man.sh</tt></dt>
<dd>Groff belge üretir. manpages dizini altında çalıştırılmalıdır.
<br/>Kullanımı: <code>xml2man.sh &lt;bölüm> &lt;isim></code>
<br/>Örnek: <code>./xml2man.sh 1 xmllint</code></dd>

<dt><tt>manpages/mandoc/xml2mdoc.sh</tt></dt>
<dd> Deneysel: mandoc belge üretir. İngilizce bölüm başlığı
dayatmasından kurtulmak mümkün görünmediğinden geliştirme
tamamlanmamıştır. Ancak *BSD'ler genelde groff belgeleri de
desteklemektedir.</dd>
```
