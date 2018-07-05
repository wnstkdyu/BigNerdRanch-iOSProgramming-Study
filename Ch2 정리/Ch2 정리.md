# Chapter 2 The Swift Language

## Swift의 타입
세 기본적인 그룹으로 나뉘어진다: *structures(구조체)*, *classes(클래스)*, *enumerations(열거형)*. 이 세 타입은 다음과 같은 것들을 가진다.

- *properties*: 타입과 관련된 값
- *initializers*: 타입의 인스턴스를 초기화하는 코드
- *intance methods*: 타입의 인스턴스에서 호출될 수 있는 함수
- *class* or *static methods*: 타입 그 자체에서 호출될 수 있는 함수

Swift의 구조체와 열거형은 다른 언어들의 그것들과 비교해 훨씬 강력한 기능을 가진다. 프로퍼티, 이니셜라이저, 메서드 뿐만이 아니라 프로토콜을 준수하고 확장(extend)될 수 있다.

Swift의 모든 "primitive(원시)" 타입은 모두 구조체로 되어 있다. 즉, 구조체가 가지는 모든 기능을 활용할 수 있다는 뜻으로 프로퍼티, 이니셜라이저, 메서드를 가질 수 있고 프로토콜 준수, 확장도 물론 가능하다.

마지막으로 Swift의 핵심 기능은 *optionals*이다. 옵셔널은 특정 타입의 값이 있거나 없을 경우 모두를 저장할 수 있다.

## 타입 추론
Swift에서는 타입을 명시하지 않아도 컴파일러가 알아서 타입을 추론한다.

예를 들어,
``` Swift
var str = "Hello, playground"
```
라고 하면 이것의 타입이 String으로 추론된다.

![](TypeInfer.png)

물론 타입의 명시도 가능하다.
``` Swift
var str: String = "Hello, playground"
```

## 콜렉션 타입
- Array: **순서가 있는** 원소들의 모음. 제네릭을 사용해 `Array<T>`로 표현되며 T는 배열이 포함하는 어떤 타입을 의미한다.
- Dictionary: key-value의 쌍으로 이루어진 **순서가 없는** 콜렉션이다. 여기서 key는 *hashable* 프로코콜을 따르며 이는 이 키 값이 unique하게 하여 키에 해당하는 값에 접근하는 것을 효율적으로 만들어 준다. 기본적인 Swift 타입은 hashable을 준수한다.
- Set: 배열과 비슷하지만 **순서가 없고 모든 원소가 hashable을 준수하는 유일한 특성을 만족**하는 콜렉션 타입이다. 순서가 없는 특성은 원소가 있는지의 여부 확인을 빠르게 해준다. 또한 Set는 Array와 Dictionary와 달리 축약법이 가능하지 않아 Set<Int>를 명시해주어야 선언이 가능하다.

## 옵셔널 언래핑
- 강제 언래핑: !를 붙여주어 강제로 옵셔널을 벗겨내는 것으로 nil이 아니라고 가정하고 처리한다. 때문에 nil일 경우 오류가 생기는 위험을 내포한다.
- 옵셔널 바인딩(Optional Binding): `if-let` 구문을 통해 임시 상수에 옵셔널을 벗긴 값을 할당하여 처리하는 방법. nil일 경우에는 처리되지 않고 넘어가기 때문에 강제 언래핑보다 안전하다.

