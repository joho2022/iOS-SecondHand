# 🥕세컨드 핸드
동네를 기준으로 중고 물품 거래하는 당근마켓 클론 프로젝트입니다.  

**진행기간** : 2024.06 ~ 2024.07 (1개월)  
**Skills** : SwiftUI, UIKit, Realm, Combine  
**Notion** : [Notion주소](https://few-recorder-a63.notion.site/b811b68c62de4cf8835dba1603f5e061)  
**팀 구성** : iOS 1명


# 📚 목차
- 📌 핵심 키워드
- 💻 결과화면
- 🔫 트러블 슈팅


# 📌 핵심 키워드

- UIKit + SwiftUI 통합해서 개발하는 것을 목표로 하였습니다.
- URLProtocol 방식으로 서버에서 내려준 JSON 데이터라고 가정하고 개발하였습니다.
- iOS의 데이터 저장 경로를 이해하고 활용하기 위해서, 기존에 Mock 상품 데이터와 같이 상품관련된 데이터는 Document경로에 저장하고 진행하였습니다.
- 동기화를 위해서 회원정보와 관련된 것은 클라우드 Realm을 활용하여 진행하였습니다.
- MVVM 구조를 채택하였습니다.

# 💻 결과화면

<img width="1205" alt="스크린샷 2024-07-21 오전 12 05 14" src="https://github.com/user-attachments/assets/a179cad1-b2d0-418f-a15c-555aaa2b1417">

---
## 로그인

| 동네 설정 | 회원가입 완료  | 로그인 |
| :--: | :--: | :--: |
| ![동네설정](https://github.com/user-attachments/assets/7132f137-8298-45da-88b5-ed82374f6b3e) | ![회원가입완료](https://github.com/user-attachments/assets/bcda7d57-09c0-45f6-b6ab-fa1f0dd738cc)  | ![로그인](https://github.com/user-attachments/assets/1d767174-078c-4af4-9b4f-9057b0c41148) |

## 필터링

| 동네 선택 | 동네 추가  | 카테고리 |
| :--: | :--: | :--: |
| ![동네선택](https://github.com/user-attachments/assets/266aac0e-6ad6-4285-a2d8-68b180248d3e) | ![동네추가](https://github.com/user-attachments/assets/e91a9b6a-e279-41ee-9606-42b8514aebd5)  | ![카테고리](https://github.com/user-attachments/assets/2c0b41d4-4f44-4536-b72b-194d1e4d893b) |

## 상품 등록

| 이미지 | 카테고리 선택 | 등록 완료 |
| :--: | :--: | :--: |
| ![상품등록-이미지](https://github.com/user-attachments/assets/2e0f602b-0f74-4cf6-8d78-ab71f933b0d8)  |  ![상품등록-카테고리](https://github.com/user-attachments/assets/d6df71cc-e19e-4e83-9378-ba867b8b6733)  | ![상품등록 - 완료](https://github.com/user-attachments/assets/b45b79c7-a42d-4d05-a07a-5d417085c0f7) |

## 버튼변화, 채팅

| 드래그 | 읽음처리 | 채팅 |
| :--: | :--: | :--: |
| ![드래그](https://github.com/user-attachments/assets/e2127cf2-a1dd-411f-80cf-ccca53e41ee5)  | ![채팅-읽음처리](https://github.com/user-attachments/assets/14baaa8d-4d10-4d7a-981f-7fb07ff3725f)   | ![채팅-상세화면](https://github.com/user-attachments/assets/084027b4-69ed-482e-af78-e33383b711b9) |

---

# 🔫 트러블 슈팅

## 1.동네 설정

**문제 설명**: 사용자가 프로필 이미지를 업데이트하거나 위치를 추가/삭제한 후,
                    UserManager의 user 속성이 최신 정보를 반영하지 않아 UI가 올바르게 업데이트되지 않는 문제가 발생했습니다.  
**해결 방법**: UserManager 클래스에 refreshUser 메서드를 추가하여
                    Realm 데이터베이스에서 최신 사용자 정보를 가져와 user 속성을 업데이트하도록 했습니다.  
**구체적인 구현**:
- refreshUser 메서드를 추가하여 사용자의 username을 기준으로 Realm 데이터베이스에서 최신 정보를 가져와 user 속성에 할당했습니다.
- updateProfileImage, addLocation, removeLocation 등의 메서드에서 데이터베이스에 변경이 발생한 후 refreshUser를 호출하여 user 속성이 항상 최신 상태를 유지하도록 했습니다.
  
**결과**: 사용자가 프로필 이미지를 업데이트하거나 위치를 추가/삭제한 후
           UI가 최신 정보를 반영하게 되어 데이터 일관성과 사용자 경험이 향상되었습니다.

## 2.상품 등록

![image](https://github.com/user-attachments/assets/5f51fe3a-60f0-49a5-86a0-558a90d7ca54)


**문제 설명**: SF Symbols의 아이콘을 사용할 때, 안의 X 표시를 흰색으로 채우려 했으나,
                    단순한 틴트 색상 변경으로는 의도한 색상이 매끄럽게 적용되지 않는 문제가 발생했습니다.  
**해결 방법**: 심볼 팔레트를 구성하여 이미지에 색상을 적용했습니다.  
**구체적인 구현**:

```swift
guard var xmarkImage = UIImage(systemName: "xmark.circle.fill") else { return UIImageView() }
        let primaryColor = UIColor.white
        let secondaryColor = UIColor.black
        
        let configuration = UIImage.SymbolConfiguration(paletteColors: [primaryColor, secondaryColor])
        xmarkImage = xmarkImage.withConfiguration(configuration)
        
        let xmarkView = UIImageView(image: xmarkImage)
```  

**결과**: 흰색과 검정색으로 이미지의 색상이 매끄럽게 적용되어 원하는 시각적 효과를 얻었습니다.

## 3.상품 등록 

**문제 설명**: UIKit으로 만든 상품 등록 뷰와 SwiftUI에서 화면 이동 시 네비게이션 바가 두 개 생기는 문제가 발생했습니다.  
**해결 방법**: fullScreenCover와 UIViewControllerRepresentable을 사용하여 
                    SwiftUI와 UIKit 간의 원활한 화면 전환을 구현했습니다.  
**구체적인 구현**:
- fullScreenCover를 사용하여 SwiftUI에서 전체 화면을 표시.
- UIViewControllerRepresentable을 통해 UIKit의 UINavigationController와 UIViewController를 통합.
- NewProductViewController에서 완료 및 닫기 이벤트를 처리하여 isPresented를 업데이트.  

**결과**: SwiftUI와 UIKit 간의 화면 전환 시 네비게이션 바가 중복되지 않으며, 일관된 사용자 경험을 제공할 수 있었습니다.  

## 4.채팅 기능

**문제 설명**: 클라우드 Realm을 사용하고 나서 상품 등록 완료 후 로그인이 풀리는 버그가 발생했습니다.  
**해결 방법**: UserManager가 EnvironmentObject로 주입될 때, ObservableObject를 준수하지 않아서 발생한 버그로 판단되었습니다. 이를 해결하기 위해 AppState 클래스에 @Published 속성 래퍼를 사용하여 userManager를 지정했습니다.  
**구체적인 구현**:

```swift
class AppState: ObservableObject {
    @Published var realm: Realm?
    @Published var userManager: UserManager?
    @Published var chatRoomViewModel: ChatRoomViewModel?
    private var app: App
    
    init() {
        self.app = App(id: "application-0-fahelom")
        let realmManager = RealmManager(realm: nil)
        self.userManager = UserManager(realmManager: realmManager)
        login()
    }

```



**결과**: 사용자가 상품 등록을 완료한 후에도 로그인이 유지되며, 데이터 일관성과 사용자 경험이 향상되었습니다.




