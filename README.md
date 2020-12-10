# 👀 imonitor - 온라인 시험 부정행위 방지 앱 플랫폼

  > 시연 동영상: https://www.youtube.com/watch?v=9g9JMfP7k7Y&feature=youtu.be
  
<img width="300" src="https://user-images.githubusercontent.com/39258902/92712708-03f0a280-f395-11ea-8161-5e381e963f27.jpg">

## 📍 주요 기능

#### 1. Eye Tracking



  - 시선 인식을 통해 부정행위를 감지


#### 2. 실시간 채점



  - 응시자가 답안을 제출한 직후 채점 결과 출력
  
  
</br>

## ⏰   프로젝트 일정
- #### 7월 31일
  - LoginViewController 레이아웃 작업 완료
  - MainViewController 레이아웃 작업 완료
- #### 8월 5일
  - DetailViewController로 데이터 로드 완료
- #### 8월 7일
  - Eyetracking 기술 연동 완료
- #### 8월 8일
  - Eyetracking count 기능 추가
  - Eyetracking 이탈 시 경고창 기능 추가 
- #### 8월 9일 
  - ExamViewController 레이아웃 작업 완료
- #### 8월 10일
  - DetailViewController 레이아웃 작업 / 데이터 로드 완료
- #### 8월 11일
  - ExamViewController 데이터 로드 완료
- #### 8월 12일
  - JSON 연동 시작
- #### 8월 14일
  - 검색 기능 레이아웃 작업 완료
- #### 8월 15일 
  - UserInfo 파싱 완료
- #### 8월 18일
  - LoginAPI 연동 완료
- #### 8월 19일
  - SignUpAPI 연동 완료
- #### 8월 20일
  - LoginViewController 경고창 작업, 페이지 이동 작업 완료
- #### 8월 26일 
  - 검색 기능 경고창 기능 작업 완료
  - CourseInfo 파싱 완료
  - JSON 파싱 후 MainViewController Table View 정보 삽입 완료
- #### 8월 27일 
  - Logout 경고창 기능 작업 완료
- #### 8월 30일
  - DetailViewController에 데이터 파싱 작업 완료
- #### 9월 1일
  - SubmitViewController 디자인 완료
- #### 9월 3일
  - Exam 데이터 로드 완료
  - AnswerList SubmitViewController에 전송
- #### 9월 4일
  - ScoreViewController -> MainViewController 이동 작업 완료 
- #### 9월 6일 ~ 9월 7일
  - Submit 정보 Post 작업 완료
- #### 9월 8일
   - Score 계산 기능 작업 완료
- #### 9월 9일
  - ScoreViewController 데이터 로드 작업 완료
- #### 9월 10일 
  - 전체적인 레이아웃 검토 및 보완
  - RxSwift - Login 작업 완료
</br>

## 💁  개발 환경
- `Swift`

- `RxSwift`


</br>


## 📝 설계 기법

#### Agile Process + Waterfall Process

> Agile Process (개발 초기)
  - 전체적인 프로젝트 기획 및 구상

</br>

> Waterfall Process
  - ERD 구축
  - 세부 기능 구축

</br>

## 👩🏻‍💻 사용 방법 
  1) SeeSo 로그인 (https://seeso.io)
  2) 라이선스 키 발급
  3) imontor -> ViewController -> Exam -> ExamViewController -> func cameraPermissionCheck()
  
``` swift

func cameraPermissionCheck(){
        if AVCaptureDevice .authorizationStatus(for: .video) == .authorized{
            GazeTracker.initGazeTracker(license: "발급받은 라이선스 키", delegate: self)
        } else {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: {
                response in
                if response{
                    GazeTracker.initGazeTracker(license: "발급받은 라이선스 키", delegate: self)
                    }
               }
        }   
}
```

</br> 

## 🗣 세부 설명
<img width="1192" alt="스크린샷 2020-09-10 오후 6 34 11" src="https://user-images.githubusercontent.com/39258902/92712134-3948c080-f394-11ea-8e5f-0630aeac09ae.png">

<img width="1235" alt="스크린샷 2020-09-11 오후 4 51 02" src="https://user-images.githubusercontent.com/39258902/92886832-fac40c00-f44e-11ea-8756-a57957ec3331.png">

<img width="1198" alt="스크린샷 2020-09-10 오후 6 34 37" src="https://user-images.githubusercontent.com/39258902/92712191-48c80980-f394-11ea-86a5-c165626f715f.png">

<img width="1195" alt="스크린샷 2020-09-10 오후 6 34 47" src="https://user-images.githubusercontent.com/39258902/92712215-4f568100-f394-11ea-8f11-bd9ed0721f46.png">

<img width="1196" alt="스크린샷 2020-09-10 오후 6 34 59" src="https://user-images.githubusercontent.com/39258902/92712237-57162580-f394-11ea-971f-6f070373cf7b.png">
