[English](README.md) | [한국어](README.ko.md)

# VPN 자동 연결 스크립트

특정 WiFi 네트워크에 연결될 때 지정된 VPN을 자동으로 연결하는 스크립트입니다.

## 🎯 이 스크립트를 만든 이유

**NetShare VPN의 불편한 점:**
- ❌ 컴퓨터가 절전 모드에서 깨어날 때마다 수동으로 재연결 필요
- ❌ 컴퓨터를 껐다가 다시 켤 때마다 수동으로 재연결 필요
- ❌ WiFi 연결이 복원될 때마다 수동으로 재연결 필요

**이 스크립트가 해결하는 문제:**
- ✅ WiFi 연결을 자동으로 감지
- ✅ 사용자 개입 없이 VPN 자동 재연결
- ✅ 백그라운드에서 원활하게 실행
- ✅ 절전/재시작 시에도 VPN 연결 유지

## 📋 사전 요구사항

1. Windows 11 운영체제
2. Windows에 VPN 연결이 이미 구성되어 있어야 함
3. Windows 자격 증명 관리자에 VPN 인증 정보가 저장되어 있어야 함

## ⭐ 주요 특징

- **수동 재연결 불필요** - 절전 모드 후 VPN 재연결을 자동으로 처리
- **원활한 사용 경험** - 사용자 개입 없이 백그라운드에서 조용히 작동
- **스마트 감지** - WiFi 변경을 모니터링하고 즉시 반응
- **다중 VPN 지원** - 서로 다른 WiFi 네트워크에 대해 다른 VPN 구성 가능
- **유연한 제어** - 자동 연결 기능을 쉽게 일시 중지, 재개 또는 제거 가능

## 📁 파일 구조

- `NetShare-AutoConnect.ps1` - 메인 모니터링 스크립트
- `Install-TaskScheduler.ps1` - 작업 스케줄러 등록 스크립트
- `Start-Monitoring.bat` - 수동 실행용 배치 파일
- `Install-AutoStart.bat` - 자동 시작 설치용 배치 파일
- `Check-Status.bat` - 상태 확인용 배치 파일
- `List-AutoConnect.bat` - 모든 자동 연결 작업 목록 표시
- `Stop-AutoConnect.bat` - 작업 중지 및 비활성화
- `Enable-AutoConnect.bat` - 비활성화된 작업 활성화
- `Remove-AllAutoConnect.bat` - 모든 작업 영구 제거
- `QuickStart-9vvin.bat` - DIRECT-NS-9vvin 네트워크용 빠른 설정
- `VPN-AutoConnect-[VPN_Name].log` - 실행 로그 파일 (자동 생성)

## 🚀 설치 방법

### 방법 1: 자동 시작 설정 (권장)

1. **관리자 권한**으로 `Install-AutoStart.bat` 실행:
   - 파일을 마우스 오른쪽 클릭 → "관리자 권한으로 실행" 선택
   
2. 필수 매개변수 입력:
   ```
   Install-AutoStart.bat "WiFi_SSID" [VPN_Name]
   ```
   
   예시:
   ```
   Install-AutoStart.bat "DIRECT-NS-9vvin"
   Install-AutoStart.bat "DIRECT-NS-9vvin" "NetShare"
   Install-AutoStart.bat "우리집WiFi" "회사VPN"
   ```

### 방법 2: 수동 실행

1. 매개변수와 함께 `Start-Monitoring.bat` 실행:
   ```
   Start-Monitoring.bat "WiFi_SSID" [VPN_Name]
   ```
   
   예시:
   ```
   Start-Monitoring.bat "DIRECT-NS-9vvin"
   Start-Monitoring.bat "DIRECT-NS-9vvin" "NetShare"
   ```

2. 스크립트가 백그라운드에서 모니터링합니다
3. 중지하려면 `Ctrl+C` 누르기

## ⚙️ 매개변수

### 필수 매개변수:
- **WiFi_SSID**: VPN 연결을 트리거하는 WiFi 네트워크 이름

### 선택적 매개변수:
- **VPN_Name**: VPN 연결 이름 (기본값: "NetShare")

## 🔍 상태 확인

현재 WiFi 및 VPN 상태 확인:

```
Check-Status.bat [WiFi_SSID] [VPN_Name]
```

예시:
```
Check-Status.bat                           # 모든 VPN 확인
Check-Status.bat "DIRECT-NS-9vvin"         # 특정 WiFi와 기본 VPN 확인
Check-Status.bat "DIRECT-NS-9vvin" "NetShare"  # 특정 WiFi와 VPN 확인
```

## 🔧 설정

모니터링 스크립트는 30초마다 확인합니다. 변경하려면 `NetShare-AutoConnect.ps1`의 `$checkInterval` 변수를 수정하세요.

## 📝 작동 원리

1. 스크립트가 30초마다 컴퓨터의 네트워크 상태를 모니터링합니다
2. 지정된 WiFi 네트워크 연결을 감지하면 자동으로 VPN을 연결합니다
3. WiFi 연결이 끊어지거나 다른 네트워크로 전환되면 VPN 연결을 해제합니다
4. **절전 모드 특별 처리**: 컴퓨터가 절전 모드에서 깨어난 후에도 계속 모니터링하여 VPN을 자동으로 재연결합니다
5. 모든 활동은 `VPN-AutoConnect-[VPN_Name].log`에 기록됩니다

이제 더 이상 절전 모드나 컴퓨터 재시작 후 NetShare VPN을 수동으로 재연결하는 번거로움이 없습니다!

## 🛠️ 문제 해결

### VPN이 자동으로 연결되지 않는 경우

1. Windows 설정에서 VPN이 구성되어 있는지 확인:
   - 설정 → 네트워크 및 인터넷 → VPN
   
2. 인증 정보가 저장되어 있는지 확인:
   - 연결 시 "내 로그인 정보 저장" 체크
   
3. 로그 파일 확인: `VPN-AutoConnect-[VPN_Name].log`

### 작업 스케줄러 등록이 실패하는 경우

1. 관리자 권한으로 실행했는지 확인
2. Windows Defender/바이러스 백신이 차단하지 않는지 확인
3. PowerShell 실행 정책 확인:
   ```powershell
   Get-ExecutionPolicy
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```

### 다중 VPN 구성

여러 WiFi/VPN 조합에 대해 여러 자동 연결 작업을 설정할 수 있습니다:

```
Install-AutoStart.bat "집WiFi" "개인VPN"
Install-AutoStart.bat "사무실WiFi" "회사VPN"
Install-AutoStart.bat "카페WiFi" "보안VPN"
```

각 구성은 작업 스케줄러에 별도의 작업을 생성합니다.

## 🎛️ 작업 관리

### 모든 자동 연결 작업 목록 보기:
```
List-AutoConnect.bat
```
구성된 모든 VPN 자동 연결 작업과 상태, 마지막 실행 시간, 다음 실행 시간을 표시합니다.

### 작업 중지/비활성화:
```
Stop-AutoConnect.bat                    # 모든 작업 중지 및 비활성화
Stop-AutoConnect.bat "VPN_Name"         # 특정 VPN 중지 및 비활성화
```
실행 중인 작업을 중지하고 자동 시작을 비활성화합니다.

### 작업 활성화/재시작:
```
Enable-AutoConnect.bat                  # 모든 비활성화된 작업 활성화
Enable-AutoConnect.bat "VPN_Name"       # 특정 VPN 활성화
```
이전에 비활성화된 작업을 다시 활성화하고 선택적으로 즉시 시작합니다.

## 🗑️ 제거

### 특정 VPN 자동 연결 제거:
1. 작업 스케줄러 열기
2. "AutoConnectVPN_[VPN_Name]" 작업 찾기
3. 마우스 오른쪽 클릭 → 삭제

### PowerShell로 제거:
```powershell
Unregister-ScheduledTask -TaskName "AutoConnectVPN_NetShare" -Confirm:$false
```

## ⚠️ 주의사항

- VPN이 Windows에 미리 구성되어 있어야 합니다
- 자동 연결을 위해 저장된 인증 정보가 필요합니다
- Windows 11 22H2 이상에서는 Credential Guard가 자동 인증에 영향을 줄 수 있습니다
- 각 VPN 구성은 별도의 로그 파일을 생성합니다
