# 👀 imonitor - 온라인 시험 부정행위 방지 앱 플랫폼

## 📍 주요 기능

#### 1. Eye Tracking



  - 시선 인식을 통해 부정행위를 감지


#### 2. 실시간 채점



  - 응시자가 답안을 제출한 직후 채점 결과 출력
  
  
</br>

## ⏰   프로젝트 일정
> 추후 업데이트 예정

</br>

## 💁  개발 환경
- `Swift`


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
```
