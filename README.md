aop-concurrent-lib
==================

Projekt biblioteki javowej opartej na paradygmie AOP (Aspect Oriented Programming)
wspomagającej programowanie wielowątkowe i synchronizację.

Narzędziem wykorzystanym do implementacji AOP jest biblioteka [AspectJ](http://www.eclipse.org/aspectj/).

Na chwilę obecną planowane jest:
* synchronizacja metod w całym projekcie (również pomiędzy klasami)
* grupowanie metod do synchronizacji (możliwe wiele grup)
* implementacja rozwiązania problemu czytelników i pisarzy
* implementacja rozwiązania problemu producentów i konsumentów

Wizja
-------------------------

Projekt będzie oparty na adnotacjach/dekoratorach typu:

`@Synchronized`

`@Synchronized("ID_1")`

`@Writer`

`@Writer("ID_1")`

`@Reader`

`@Reader("ID_1")`

`@Producer`

`@Producer("ID_1")`

`@Consumer`

`@Consumer("ID_1")`

Odpowiednie aspekty będą opakowywać metody z powyższymi adnotacjiami i dodawać obsługę
odpowiedniej synchronizacji.

Git workflow
-------------------------

Wszystko jak w artykule [tutaj](http://nvie.com/posts/a-successful-git-branching-model/).
Branche master i develop posiadają domyślną opcje `--no-ff`.

![Workflow](http://nvie.com/img/2009/12/Screen-shot-2009-12-24-at-11.32.03.png)