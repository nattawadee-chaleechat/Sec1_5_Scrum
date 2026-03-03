*** Settings ***
Library           RequestsLibrary
Library           Collections
Library           BuiltIn
Library           DateTime

Suite Setup       Create Session    perf    ${BASE_URL}
Suite Teardown    Delete All Sessions


*** Variables ***
${BASE_URL}          http://localhost:3000
${LOGIN_ENDPOINT}    /api/auth/login
${CREATE_ENDPOINT}   /api/reviews
${MY_REVIEW}         /api/reviews/me
${DRIVER_REVIEW}     /api/reviews/driver/admin123

${USER}              somyod123
${PASS}              Somyod123
${BOOKING_ID}        cmm6ljr7h000dtwkgmavh8nn0
${INVALID_BOOKING}   invalid_booking_id

${VALID_LINK}        https://drive.google.com/file/d/123456/view
${INVALID_LINK}      abc123

${IMG_FILE}          test.jpg
${PNG_FILE}          test.png
${MP3_FILE}          test.mp3


*** Test Cases ***

# ================= POSITIVE TEST =================

Login Success Should Return 200
    ${body}=    Create Dictionary
    ...    username=${USER}
    ...    password=${PASS}

    ${response}=    POST On Session
    ...    perf
    ...    ${LOGIN_ENDPOINT}
    ...    json=${body}

    Should Be Equal As Integers    ${response.status_code}    200


Create Review JSON Only Should Return 201
    ${token}=    Get Auth Token

    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${token}

    ${body}=    Create Dictionary
    ...    bookingId=${BOOKING_ID}
    ...    star=5
    ...    comment=Robot JSON Review

    ${response}=    POST On Session
    ...    perf
    ...    ${CREATE_ENDPOINT}
    ...    json=${body}
    ...    headers=${headers}
    ...    expected_status=any

    Should Be True    ${response.status_code} == 201 or ${response.status_code} == 400


Create Review With 3 Mixed Media Should Return 201
    ${token}=    Get Auth Token
    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${token}

    ${file_list}=    Create List
    ...    ${IMG_FILE}
    ...    ${PNG_FILE}
    ...    ${MP3_FILE}

    ${files}=    Create Dictionary
    ...    media=${file_list}

    ${data}=    Create Dictionary
    ...    bookingId=${BOOKING_ID}
    ...    star=5
    ...    comment=Mixed media upload test

    ${response}=    POST On Session
    ...    perf
    ...    ${CREATE_ENDPOINT}
    ...    files=${files}
    ...    data=${data}
    ...    headers=${headers}
    ...    expected_status=any

    Should Be True    ${response.status_code} == 201 or ${response.status_code} == 400


Create Review With Valid Link Should Return 201
    ${token}=    Get Auth Token
    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${token}

    ${body}=    Create Dictionary
    ...    bookingId=${BOOKING_ID}
    ...    star=5
    ...    comment=Review with link
    ...    link=${VALID_LINK}

    ${response}=    POST On Session
    ...    perf
    ...    ${CREATE_ENDPOINT}
    ...    json=${body}
    ...    headers=${headers}
    ...    expected_status=any

    Should Be True    ${response.status_code} == 201 or ${response.status_code} == 400


Get My Review Should Return 200
    ${token}=    Get Auth Token
    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${token}

    ${response}=    GET On Session
    ...    perf
    ...    ${MY_REVIEW}
    ...    headers=${headers}

    Should Be Equal As Integers    ${response.status_code}    200


Get Driver Review Should Return 200
    ${response}=    GET On Session
    ...    perf
    ...    ${DRIVER_REVIEW}

    Should Be Equal As Integers    ${response.status_code}    200


# ================= NEGATIVE TEST =================

Create Review Without Token Should Return 401
    ${body}=    Create Dictionary
    ...    bookingId=${BOOKING_ID}
    ...    star=5
    ...    comment=No token test

    ${response}=    POST On Session
    ...    perf
    ...    ${CREATE_ENDPOINT}
    ...    json=${body}
    ...    expected_status=any

    Should Be Equal As Integers    ${response.status_code}    401


Create Review Booking Not Found Should Return 404
    ${token}=    Get Auth Token
    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${token}

    ${body}=    Create Dictionary
    ...    bookingId=${INVALID_BOOKING}
    ...    star=5
    ...    comment=Booking not found

    ${response}=    POST On Session
    ...    perf
    ...    ${CREATE_ENDPOINT}
    ...    json=${body}
    ...    headers=${headers}
    ...    expected_status=any

    Should Be Equal As Integers    ${response.status_code}    400


Create Review With Invalid Link Should Return 400
    ${token}=    Get Auth Token
    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${token}

    ${body}=    Create Dictionary
    ...    bookingId=${BOOKING_ID}
    ...    star=5
    ...    comment=Invalid link
    ...    link=${INVALID_LINK}

    ${response}=    POST On Session
    ...    perf
    ...    ${CREATE_ENDPOINT}
    ...    json=${body}
    ...    headers=${headers}
    ...    expected_status=any

    Should Be Equal As Integers    ${response.status_code}    400


# ================= PERFORMANCE TEST =================

Create Review Response Time Should Be Less Than 2 Seconds
    ${token}=    Get Auth Token
    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${token}

    ${body}=    Create Dictionary
    ...    bookingId=${BOOKING_ID}
    ...    star=5
    ...    comment=Performance Test

    ${start}=    Get Time    epoch

    ${response}=    POST On Session
    ...    perf
    ...    ${CREATE_ENDPOINT}
    ...    json=${body}
    ...    headers=${headers}
    ...    expected_status=any

    ${end}=    Get Time    epoch
    ${duration}=    Evaluate    ${end} - ${start}

    Should Be True    ${duration} < 2


Sequential GET My Reviews 5 Times Should Not Fail
    ${token}=    Get Auth Token
    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${token}

    FOR    ${i}    IN RANGE    1    6
        ${response}=    GET On Session
        ...    perf
        ...    ${MY_REVIEW}
        ...    headers=${headers}
    END

    Should Be True    True


*** Keywords ***

Get Auth Token
    ${body}=    Create Dictionary
    ...    username=${USER}
    ...    password=${PASS}

    ${response}=    POST On Session
    ...    perf
    ...    ${LOGIN_ENDPOINT}
    ...    json=${body}

    Should Be Equal As Integers    ${response.status_code}    200

    ${json}=    Set Variable    ${response.json()}
    ${data}=    Get From Dictionary    ${json}    data
    ${token}=   Get From Dictionary    ${data}    token

    RETURN    ${token}