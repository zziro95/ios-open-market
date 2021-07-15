# 오픈마켓 프로젝트
- 프로젝트 기간: 2021.01.25 ~ 2021.02.07    
- 팀 프로젝트 : [찌로](https://github.com/zziro95) / [리나](https://github.com/GREENOVER) :man_technologist::man_technologist:    
- [팀 그라운드 룰](https://github.com/zziro95/ios-exposition-universelle/blob/step3/GroundRule.md) 
---
## 구현된 기능
- 서버 `API` 문서를 고려하여 모델 타입 구현
- 서버 `API` 와 통신할 타입 구현
- 네트워크 통신에 대한 테스트 코드 작성을 통해 `CRUD` 기능 테스트
- 네트워크가 되지 않는 상황에서 `Mock` 객체를 통한 `UnitTest`
- 뷰를 코드와 스토리보드 방식 모두 사용하여 구현 
<br>

<img src="https://github.com/zziro95/ios-open-market/blob/1-zziro-lina/images/appgif.gif" width="20%" height="20%" title="appgif" alt="appgif"></img> <br>

---
## 🎯 트러블 슈팅
### 1. 네트워크 통신이 불가능한 상황에 대한 테스트
- 문제 상황
    - 네트워킹은 서버의 상황에 의존할 수밖에 없습니다. 
    - 서버가 점검이 길어지거나 이용하지 못하는 상황이라면 메서드 구현하더라도 잘 동작하는지 테스트할 수 없습니다.   
    - 또한 네트워킹을 이용하여 테스트를 이용하면 속도가 느리다는 단점도 있습니다.   
- 해결 방법
    - `URLSessionProtocol` 을 선언하여 `NetworkHandler`에서 `MockURLSession`을 사용할 수 있도록 정의하였습니다.
    - `MockURLSession` 정의하고 성공과 실패에 따른 `Data`, `URLResponse`, `Error`를 넘겨주도록 코드를 작성하였습니다.
    - `MockURLSession` 을 이용해 네트워크 통신이 불가능한 상황에서도 코드가 정상적인 기능을 하는지 테스트할 수 있었습니다.   
```swift
protocol URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol { }

struct NetworkHandler {
    let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    ...
}

// MockURLSession의 dataTask()
func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
    let successResponse = HTTPURLResponse(url: MockAPI.baseURL,
                                          statusCode: 200,
                                          httpVersion: "2",
                                          headerFields: nil)
    let failureResponse = HTTPURLResponse(url: MockAPI.baseURL,
                                          statusCode: 410,
                                          httpVersion: "2",
                                          headerFields: nil)
    let sessionDataTask = MockURLSessionDataTask()
    
    sessionDataTask.resumeDidCall = {
        if self.isSuccess {
            completionHandler(self.data, successResponse, nil)
        } else {
            completionHandler(nil, failureResponse, nil)
        }
    }
    self.sessionDataTask = sessionDataTask
    return sessionDataTask
}
```   
💡 코드를 작성하는데 [우아한 형제들 기술 블로그](https://techblog.woowahan.com/2704/)를 참고하였습니다.   
<br>

### 2. 중복되는 코드에 대한 수정
- 문제 상황
    - 서버에 다른 `Path`로 요청할 때 다른 `response`를 돌려주는 경우도 있기 때문에 넘겨져 오는 데이터를 디코딩 하려면 어떤 모델 타입에 매칭해야 할지 정해주고 처리해 주어야 했습니다.
    - 이 과정에서 아래와 같은 코드를 짜면 `Product`라는 타입의 데이터를 넘겨받을 시 디코딩 할 수 있지만, `ProductList` 타입 데이터를 디코딩 하기 위해서 메서드를 만들었을 때 같은 코드가 중복됨을 느꼈습니다.
    - 새로운 `Path`로 새로운 타입의 데이터를 받아와야 하는 경우 또한 발생할 수 있습니다.
    - 그렇다면 그에 매칭할 모델 타입을 만들어 주는 건 당연하지만 같은 구조의 디코딩 메서드가 쌓이게 됩니다.
    - 서로 다른 모델 타입이 `10~100`개가 있다면 같은 구조지만 어떤 타입을 디코딩 해주고 리턴해주는지만 다른 메서드들이 중복되게 될 것입니다.
    - 이를 어떻게 해결해야 할지 고민해 보았습니다.   
    - 아래의 코드는 제네릭을 이용하여 해결하기 전 코드이며 제네릭을 사용하지 않는다면 `decodeData()`와 같은 구조의 메서드가 여러 개 생기며 같은 구조의 코드가 중복됩니다.
```swift
struct ProductJSONDecoder {
    static let decoder = JSONDecoder()

    static func decodeData(completionHandler: @escaping (Result<Products, StringFormattingError>) -> ()) {
        ProductAPIManager.shared.startLoad { result in
            switch result {
            case .success(let data):
                do {
                    let productList = try decoder.decode(Products.self, from: data)
                    completionHandler(.success(productList))
                } catch {
                    completionHandler(.failure(.decodingFailure))
                }
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}
```   

- 해결 방법
    - 스위프트의 강점 중 하나인 `Generic`은 이 문제를 해결할 수 있음을 알게 되었습니다. 
    - `<T: Decodable>`를 선언함으로써 `Decodable`을 채택한 타입만 다룰 수 있게 하였습니다.
    - 아래 코드와 같이 타입 파라미터를 사용하여 정의해 주어 `decodeData()` 메서드는 네트워킹을 통해 데이터를 받고 그 데이터를 `Decodable` 한 타입에 매칭해 파싱하여 리턴해줍니다.   
    - `Generic`으로 만들어진 코드의 `T - Type Parameter` 는 동일한 타입이어야 하기 때문에 `Product` 타입으로 디코딩하고자 하면 `Product` 타입에 매칭해 디코딩 되어 `completionHandler` 를 통해 리턴됩니다.
    - `Product`, `ProductList` 또는 새로운 모델 타입의 데이터를 디코딩 해야 하더라도 아래의 메서드를 사용하면 되기 때문에 코드의 중복을 줄이고, 유연하고 재사용성은 높은 코드가 되었습니다.    
```swift
struct OpenMarketJSONDecoder<T: Decodable> {

    static func decodeData(about type: OpenMarketAPIManager.APIType, specificNumer number: Int, completionHandler: @escaping (Result<T, StringFormattingError>) -> ()){
        let decoder = JSONDecoder()

        OpenMarketAPIManager.startLoad(about: type, specificNumer: number) { result in
            switch result {
            case .success(let data):
                do {
                    let productList = try decoder.decode(T.self, from: data)
                    completionHandler(.success(productList))
                } catch {
                    completionHandler(.failure(.decodingFailure))
                }
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}
```   
- [해당 커밋](https://github.com/zziro95/ios-open-market/commit/39deb35047ba5e08ac221b8966daf6f633080add)
<br>

### 3. 오토 레이아웃 에러
- 문제 상황
    - 코드로 오토 레이아웃을 작성하면서 여러 어려움이 있었습니다.
    - 머릿속으로 상상하며 코드로 작성해 주어야 했고, 제약이 잘 설정되었는지 확인하는 작업이 스토리보드 보다 불편하다고 느껴졌습니다.
    - 그러나 코드로 뷰를 그리고 제약을 설정할 경우 재사용성이 높아지고, 스토리보드로 협업하는 과정에서 발생하는 `Conflict`를 해결하는 것보다 훨씬 수월하였습니다.
    - 테이블 뷰 셀을 코드로 작성해 주는 작업에서 뷰는 잘 보이지만 아래와 같은 에러 문구가 출력되었습니다.   
<img src="https://github.com/zziro95/ios-open-market/blob/1-zziro-lina/images/LayoutConstraintError.png" width="70%" height="70%" title="LayoutConstraintError" alt="LayoutConstraintErrorImg"></img> <br>
- 해결 방법
    - 우선 위의 에러 문구를 해석할 수가 없었습니다.
    - 나중에서야 `Visual Format` 형식이라는 것을 알게 되었지만 프로젝트 진행 기간에는 알지 못하여 관련 서칭을 해보았습니다.
    - 살펴본 결과 오토 레이아웃 에러를 해석해 주는 [WTF Auto Layout?](https://www.wtfautolayout.com/) 사이트를 알게 돼 어떤 문제가 있는지 알아보았습니다.
    - 아래 사진을 보면 `ImageView`에 `ImageView`의 `width`와 같은 `height`이 걸려있고, `TableViewCellContentView` 의 `top, bottom edge`와 같게 `top, bottom` 제약이 들어가 있습니다.
    - `ImageView` 이미지 뷰의 `height`에 대한 제약이 여러 곳에서 걸려있고, 어떤 제약을 통해 레이아웃이 자리 잡혀야 하는지 알 수 없는 에러가 발생한 것이었습니다.
    - `ImageView` 의 `top`, `height` 에 대한 제약은 그대로 두고, `bottom` 에 대한 제약을 제거해주어 오토 레이아웃에 대한 에러를 해결하였습니다.    
<img src="https://github.com/zziro95/ios-open-market/blob/1-zziro-lina/images/WTFAutoLayout.png" width="70%" height="70%" title="WTFAutoLayout" alt="WTFAutoLayoutImg"></img> <br>

- [해당 커밋](https://github.com/zziro95/ios-open-market/commit/3cd47aed1ff9bd6279f2294dc6b678bd9471cc15)
<br>

---
## 💡 고민한 점
### 1. 모델의 프로퍼티 타입
- 고민한 점
    - 서버로부터 데이터를 받아오는데 필수 데이터에 대한 정의가 없었습니다. 
    - 팀의 기준에서 `꼭 필요한 데이터는 무엇인지`, `UI에 보여야 하는 데이터는 무엇인지`를 정해 선언을 해도 될지 고민하였습니다.    
- 해결 방안
    - 어떤 데이터가 필수로 들어오는지는 문서에 정의되어 있거나, 협업을 하면서 위와 같은 기준으로 정해볼 수도 있을 것 같습니다.
    - 그러나 정한다 하더라도 여러 상황에 의해 데이터가 누락될 수도 있고, 그 데이터가 필수적이라는 건 보장할 수 없습니다.
    - 따라서 모든 프로퍼티에 `Optional`을 선언해 주었고, 인스턴스의 쓰임에 따라 알맞은 `init`을 선언해 주었습니다.   
```swift
init(forPostPassword password: String, title: String, descriptions: String, price: Int, currency: String, stock: Int, discountedPrice: Int? = nil, images: [String]) {
    self.password = password
    self.title = title
    self.descriptions = descriptions
    self.price = price
    self.currency = currency
    self.stock = stock
    self.discountedPrice = discountedPrice
    self.imageURLs = images
    
    self.id = nil
    self.thumbnailURLs = nil
    self.timeStampDate = nil
}

init(forPatchPassword password: String, title: String? = nil, descriptions: String? = nil, price: Int? = nil, currency: String? = nil, stock: Int? = nil, discountedPrice: Int? = nil, images: [String]? = nil) {
    self.password = password
    self.title = title
    self.descriptions = descriptions
    self.price = price
    self.currency = currency
    self.stock = stock
    self.discountedPrice = discountedPrice
    self.imageURLs = images

    self.id = nil
    self.thumbnailURLs = nil
    self.timeStampDate = nil
}
```   
