*** Settings ***
Library    SeleniumLibrary
Library    DatabaseLibrary
Library    RequestsLibrary

Suite Setup       Set Selenium Speed    0.2s
Suite Setup       Create API Session
Test Setup        Open Fresh Browser
Test Teardown     Close Browser


*** Variables ***
${TEST_URL}    http://localhost:3001
${API_URL}     http://localhost:3000/api
${BROWSER}     edge
${TIMEOUT}     15s

${DNAME}       admin123
${DPASS}       123456789
${PNAME}       somsee123
${PPASS}       Somsee123

${IMAGE_OK}      C:/Users/sutti/Downloads/Media/Picture.png
${VIDEO_OK}      C:/Users/sutti/Downloads/Media/MP4.mp4
${AUDIO_OK}      C:/Users/sutti/Downloads/Media/MP3.mp3
${IMAGE_BIG}     C:/Users/sutti/Downloads/Media/OversizePicture.jpg

${DRIVE_LINK}    https://drive.google.com/file/d/123456/view
${BAD_LINK}      https://example.com/file

${DBNAME}    db
${DBUSER}    postgres
${DBPASS}    110913
${DBHOST}    localhost
${DBPORT}    5432


*** Test Cases ***

# ================= CREATE REVIEW =================

Valid Review With Full Data
    Reset Booking State
    Passenger Finish Trip
    Driver Finish Trip
    Open Review Page
    Give Score    5
    Input Text    xpath=//textarea    รีวิวครบทุกไฟล์
    Input Text    xpath=//input[@type='text']    ${DRIVE_LINK}
    Choose File    xpath=//input[@type='file']    ${IMAGE_OK}\n${VIDEO_OK}\n${AUDIO_OK}
    Click Submit Success

Valid Review Without Media
    Reset Booking State
    Passenger Finish Trip
    Driver Finish Trip
    Open Review Page
    Give Score    4
    Input Text    xpath=//textarea    ดีมาก
    Click Submit Success

Valid Review Without Comment
    Reset Booking State
    Passenger Finish Trip
    Driver Finish Trip
    Open Review Page
    Give Score    3
    Choose File    xpath=//input[@type='file']    ${IMAGE_OK}
    Click Submit Success

Valid Review Rating Only
    Reset Booking State
    Passenger Finish Trip
    Driver Finish Trip
    Open Review Page
    Give Score    3
    Click Submit Success

Valid Review Media Only
    Reset Booking State
    Passenger Finish Trip
    Driver Finish Trip
    Open Review Page
    Give Score    4
    Choose File    xpath=//input[@type='file']    ${IMAGE_OK}\n${VIDEO_OK}
    Click Submit Success

Valid Review Drive Link Only
    Reset Booking State
    Passenger Finish Trip
    Driver Finish Trip
    Open Review Page
    Give Score    4
    Input Text    xpath=//input[@type='text']    ${DRIVE_LINK}
    Click Submit Success

Invalid Review Without Rating
    Reset Booking State
    Passenger Finish Trip
    Driver Finish Trip
    Open Review Page
    Input Text    xpath=//textarea    ไม่มีคะแนน
    Click Submit Expect Score Error

Invalid Review Oversize Image
    Reset Booking State
    Passenger Finish Trip
    Driver Finish Trip
    Open Review Page
    Give Score    4
    Choose File    xpath=//input[@type='file']    ${IMAGE_BIG}
    Click Submit Expect Upload Error

Invalid Review Non Google Drive Link
    Reset Booking State
    Passenger Finish Trip
    Driver Finish Trip
    Open Review Page
    Give Score    4
    Input Text    xpath=//input[@type='text']    ${BAD_LINK}
    Click Submit Expect Invalid Link

Invalid Review After 7 Days
    Reset Booking State
    Passenger Finish Trip
    Driver Finish Trip
    Set Booking Completed 8 Days Ago
    Login    ${PNAME}    ${PPASS}
    Go To    ${TEST_URL}/myTrip
    Wait Until Element Is Visible    xpath=//button[contains(.,'การเดินทางเสร็จสิ้น')]    15s
    Click Element    xpath=//button[contains(.,'การเดินทางเสร็จสิ้น')]
    Page Should Not Contain Element    xpath=//button[contains(.,'รีวิวการเดินทาง')]
    Wait Until Page Contains    หมดเวลารีวิวแล้ว (เกิน 7 วัน)    10s


# ================= VIEW REVIEW =================

Guest Can View Driver Review
    Go To Find Trip Page
    Click First Review Button
    Review Popup Should Appear
    Review Modal Should Show Reviews

Passenger Can View Driver Review
    Login    ${PNAME}    ${PPASS}
    Go To Find Trip Page
    Click First Review Button
    Review Popup Should Appear
    Review Modal Should Show Reviews

Driver Can View Driver Review
    Login    ${DNAME}    ${DPASS}
    Go To Find Trip Page
    Click First Review Button
    Review Popup Should Appear
    Review Modal Should Show Reviews

Admin Can View Driver Review
    Login    ${DNAME}    ${DPASS}
    Go To Find Trip Page
    Click First Review Button
    Review Popup Should Appear
    Review Modal Should Show Reviews

Filter Review (5-1)
    Go To Find Trip Page
    Click First Review Button
    Review Popup Should Appear
    Review Modal Should Show Reviews
    Validate Filter    5
    Validate Filter    4
    Validate Filter    3
    Validate Filter    2
    Validate Filter    1


*** Keywords ***

Create API Session
    Create Session    api    ${API_URL}

Reset Booking State
    Create Session    reset    ${API_URL}
    ${res}=    POST On Session    reset    /test/reset-bookings
    Should Be Equal As Integers    ${res.status_code}    200

Set Booking Completed 8 Days Ago
    Create Session    reset    ${API_URL}
    ${res}=    POST On Session    reset    /test/set-completed-8-days
    Should Be Equal As Integers    ${res.status_code}    200

Open Fresh Browser
    Open Browser    ${TEST_URL}    ${BROWSER}
    Maximize Browser Window
    Set Selenium Timeout    ${TIMEOUT}


Wait For Page Stable
    Wait Until Page Contains Element    //body    10s


Login
    [Arguments]    ${USER}    ${PASS}
    Go To    ${TEST_URL}/login
    Wait Until Element Is Visible    id=identifier    15s
    Input Text    id=identifier    ${USER}
    Input Text    id=password      ${PASS}
    Click Element    css=button[type="submit"]
    Wait Until Page Does Not Contain Element    css=a[href="/login"]    10s


Logout
    Mouse Over    xpath=//div[contains(@class,'hover:bg-blue-50')]
    Wait Until Element Is Visible    xpath=//button[contains(.,'Logout')]    10s
    Click Element    xpath=//button[contains(.,'Logout')]


Give Score
    [Arguments]    ${index}
    Wait Until Element Is Visible    css=.cursor-pointer    10s
    Click Element    xpath=(//span[contains(@class,'cursor-pointer')])[${index}]

# ================= FINISH TRIP =================

Passenger Finish Trip
    Login    ${PNAME}    ${PPASS}
    Go To    ${TEST_URL}/myTrip
    Wait Until Element Is Visible    xpath=//button[contains(.,'ยืนยันแล้ว')]    15s
    Click Element    xpath=//button[contains(.,'ยืนยันแล้ว')]
    Wait Until Element Is Visible    xpath=//button[contains(.,'สิ้นสุดการเดินทาง')]    10s
    Click Element    xpath=//button[contains(.,'สิ้นสุดการเดินทาง')]
    Wait Until Element Is Visible    xpath=//button[contains(.,'ใช่! สิ้นสุดการเดินทาง')]    10s
    Click Element    xpath=//button[contains(.,'ใช่! สิ้นสุดการเดินทาง')]
    Logout

Driver Finish Trip
    Login    ${DNAME}    ${DPASS}
    Go To    ${TEST_URL}/myRoute
    Wait Until Element Is Visible    xpath=//button[contains(.,'ยืนยันแล้ว')]    15s
    Click Element    xpath=//button[contains(.,'ยืนยันแล้ว')]
    Wait Until Element Is Visible    xpath=//button[contains(.,'สิ้นสุดการเดินทาง')]    10s
    Click Element    xpath=//button[contains(.,'สิ้นสุดการเดินทาง')]
    Wait Until Element Is Visible    xpath=//button[contains(.,'ใช่! สิ้นสุดการเดินทาง')]    10s
    Click Element    xpath=//button[contains(.,'ใช่! สิ้นสุดการเดินทาง')]
    Logout

Open Review Page
    Login    ${PNAME}    ${PPASS}
    Go To    ${TEST_URL}/myTrip
    Wait Until Element Is Visible    xpath=//button[contains(.,'การเดินทางเสร็จสิ้น')]    15s
    Click Element    xpath=//button[contains(.,'การเดินทางเสร็จสิ้น')]
    Wait Until Element Is Visible    xpath=//button[contains(.,'รีวิวการเดินทาง')]    10s
    Click Element    xpath=//button[contains(.,'รีวิวการเดินทาง')]

Click Submit Success
    Wait Until Element Is Visible    xpath=//button[normalize-space()='ส่งรีวิว']    10s
    Click Element    xpath=//button[normalize-space()='ส่งรีวิว']
    Wait Until Page Contains    ส่งรีวิวสำเร็จ    20s


Click Submit Expect Score Error
    Wait Until Element Is Visible    xpath=//button[normalize-space()='ส่งรีวิว']    10s
    Click Element    xpath=//button[normalize-space()='ส่งรีวิว']
    Wait Until Page Contains    กรุณาให้คะแนนก่อนส่งรีวิว    10s


Click Submit Expect Upload Error
    Wait Until Element Is Visible    xpath=//button[normalize-space()='ส่งรีวิว']    10s
    Click Element    xpath=//button[normalize-space()='ส่งรีวิว']
    Wait Until Page Contains    ไฟล์ต้องไม่เกิน 20MB    10s


Click Submit Expect Invalid Link
    Wait Until Element Is Visible    xpath=//button[normalize-space()='ส่งรีวิว']    10s
    Click Element    xpath=//button[normalize-space()='ส่งรีวิว']
    Wait Until Page Contains    แนบลิงก์ได้เฉพาะ Google Drive เท่านั้น    10s


# ================= VIEW REVIEW =================

Go To Find Trip Page
    Go To    ${TEST_URL}/findTrip
    Wait Until Element Is Visible
    ...    xpath=(//div[contains(@class,'flex text-yellow-400')])[1]    15s

Click First Review Button
    Wait Until Element Is Visible
    ...    xpath=(//div[contains(@class,'flex text-yellow-400')])[1]    15s
    Scroll Element Into View
    ...    xpath=(//div[contains(@class,'flex text-yellow-400')])[1]
    Execute Javascript
    ...    document.evaluate("(//div[contains(@class,'flex text-yellow-400')])[1]", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue.click();

Review Popup Should Appear
    Wait Until Page Contains    รีวิวทั้งหมด    15s

Review Modal Should Show Reviews
    ${has_no_review}=    Run Keyword And Return Status
    ...    Page Should Contain    ยังไม่มีรีวิว
    IF    ${has_no_review}
        Log    No reviews found — modal opened successfully
    ELSE
        Page Should Contain Element
        ...    xpath=//div[contains(@class,'border-b')]
    END

Click Star Filter
    [Arguments]    ${star}
    IF    ${star} == 0
        ${locator}=    Set Variable
        ...    xpath=//button[contains(normalize-space(.),'ทั้งหมด')]
    ELSE
        ${locator}=    Set Variable
        ...    xpath=//button[contains(normalize-space(.),'${star} ★')]
    END
    Wait Until Element Is Visible    ${locator}    15s
    Scroll Element Into View         ${locator}
    Click Element                    ${locator}


Validate Filter 
    [Arguments]    ${star}
    Click Star Filter    ${star}

    ${text}=    Get Text
    ...    xpath=//button[contains(normalize-space(.),'${star} ★')]

    ${expected}=    Evaluate
    ...    int("${text}".split("(")[1].split(")")[0])

    ${actual}=    Get Element Count
    ...    xpath=//div[@class='modal-content']//div[contains(@class,'p-3') and .//div[contains(@class,'text-yellow-400')]]

    Should Be Equal As Integers    ${actual}    ${expected}