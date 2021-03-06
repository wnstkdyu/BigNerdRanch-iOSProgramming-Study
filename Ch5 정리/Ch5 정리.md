# Chapter 5 View Controllers
모든 뷰 컨트롤러는 `UIViewController`를 상속하여 중요한 프로퍼티를 가짐.
``` Swift
var view: UIView!
```

이 프로퍼티는 뷰 컨트롤러의 뷰 계층 구도에서 최상위 뷰를 의미한다. 만약 뷰 컨트롤러의 뷰가 윈도우의 하위 뷰로 추가되면 뷰 컨트롤러의 전체 뷰 계층 구조가 윈도우에 추가된다.

> 뷰 컨트롤러의 view는 **lazy loading** 방식을 통해 보여줄 필요가 있을 때만 만들어짐으로써 메모리 절약과 성능 향상을 이룬다.

뷰 컨트롤러가 뷰 계층 구조를 만드는 방법에는 두 가지가 있다.
- 인터페이스 빌더를 통해 만드는 방법
- `UIViewController` 메서드인 `loadView()`를 오버라이드 하는 방법


