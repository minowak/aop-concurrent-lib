AOP Concurrent lib

Wizja
-------------------------

Celem projektu jest stworzenie biblioteki ułatwiającej synchronizację wątków, oraz rozwiązującej niektóre problemy współbieżności.

Nasz projekt oparty został o adnotacje Javy:

`@Synchronized`

`@Reader/@Writer`

`@Producer/@Consumer`

które odpowiednio chronią dostęp do sekcji krytycznych.

Zastosowanie adnotacji pozwoliło na prostą synchronizację funkcji z różnych klas a nawet z różnych pakietów. Dodatkowo, każda adnotacja może zostać zparametryzowana, dzieki czemu będzie można stworzyć wiele sekcji krytycznych niezależnych od siebie.

Na podobnej zasadzie działać powinni czytelnicy/pisarze oraz producenci/konsumenci.

Technologie
------------------------

Do implementacji użyjemy aspektowego rozszerzenia języka Java - AspectJ

Jako środowikso developerskie wybraliśmy Eclipse, ze względu na łatwą integrację AspectJ (`eclipse.org/aspectj/‎`) i wcześniejsze doświadczenie z tym IDE.

Repozytorium kodu zostało umieszczone na GitHubie pod adresem

`https://github.com/minowak/aop-concurrent-lib`

Projekt został podzielony na trzy milestone’y:

* `0.1` - implementacja adnotacji @Synchronized i aspektu zajmującego się kontrolą dostępu do sekcji krytycznej oraz testy.

* `0.2` - implementacja problemu czytelników i pisarzy oraz testy

* `0.3` - problem producentów/konsumentów oraz testy

Ponadto w trakcie implementacji wprowadzona została kolejna podwersja 0.3.1, w której wprowadziliśmy aspekt odpowiedzialny za logowanie użycia sekcji krytycznej.

Rozwiązanie
--------------------------

Jako, niemożliwe jest napisanie deterministycznych testów dla problemów współbierznych, logger ten pozwolił nam na monitorowanie działania zaimplementowanych aspektów przy dużej ilośći danych oraz wychwycenie możliwych błedów dzięki czemu mogliśmy sprawdzić poprawność naszych aspektów.

Dodatkowo zaimplementowane zostały testy jednostkowe sprawdzające tylko poprawne scenariusze. Przy takim założeniu testy zawsze powinny przechodzić co w powiązaniu z powyższym loggerem umożliwiło nam niemalże 100% pewność poprawnośći działania naszej biblioteki.

Po dłuższym researchu doszliśmy do wniosku, że takie rozwiązanie jest najlepszym z możliwych.

Stworzyliśmy aspekty oraz adnotacje rozwiązujące problemy:

* dostępu do sekcji krytycznej

* czytelników i pisarzy

* producentów i konsumentów


Wszystkie adnotacje mogą być parametryzowane:

* `@Synchronized` - id

* `@Reader/@Writer` - library

* `@Producer/@Consumer` - buffer

Co pozwala na tworzenie niezależnych od siebie synchronizowanych grup metod.

Dostęp do sekcji krytycznej został oparty na mapie mutexów (reprezentowanych jako Object). Dodatkowo stworzyliśmy również jeden dodatkowy mutex, który obsługuje nie parametryzowane adnotacje.

Wszystkie metody adnotowane jednym z powyższych sposobów zostaną wykryte przez odpowiednie aspekty (pointcuty zdefiniowane na wykrywanie adnotowanych metod, niezależnie od nazwy, zwracanej wartosci oraz parametrów) i użyją na nich rady ‘around’.

Dzięki temu cała kotrola dostępu wykona się naokoło wywołania funkcji docelowej.

Do problemu czytelników i pisarzy skorzystaliśmy z rozwiązania preferującego czytelników.

W przypadku problemu producentów/konsumentów sprawa wygląda trochę inaczej.

Adnotacja @Producer powinna znaleźć się nad metodą ‘produkującą’, czyli taką która dodaje do bufora. Dodatkowo należy określić rozmiar bufora

`@Producer(buffer=”buf1”, size=125)`

Podobnie z adnotacją dla konsumenta. Przed metodą wyciągająca dane z bufora

`@Consumer(buffer=”buf1”, size=125)`

Adnotacje te nie tworzą nowego bufora (należy go stworzyć samemu), odpowiadają tylko za odpowiednią synchronizację. Dzięki temu metody konsumenckie jak i producenckie mogą się znajdować w różnych klasach albo pakietach, wymagany jest tylko wspólny bufor o dowolnej zawartości.

Git workflow
-------------------------

Wszystko jak w artykule [tutaj](http://nvie.com/posts/a-successful-git-branching-model/).
Branche master i develop posiadają domyślną opcje `--no-ff`.

![Workflow](http://nvie.com/img/2009/12/Screen-shot-2009-12-24-at-11.32.03.png)