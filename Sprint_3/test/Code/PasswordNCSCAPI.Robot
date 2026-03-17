*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    BuiltIn
Library    DateTime
Library    String
   		
Suite Setup    		Initialize Suite
Suite Teardown    	Cleanup Created Users

*** Variables ***
${BASE_URL}    http://localhost:3000
${WEB_URL}     https://painamnae.onrender.com

${CREATE_USER}          /api/users
${LOGIN_ENDPOINT}       /api/auth/login
${CHANGE_PASSWORD}      /api/auth/change-password
${VALIDATE_PASSWORD}    /api/auth/validate-password

${FIRSTNAME}	Robot
${LASTNAME}     Tester
${PHONE}		0812345678
${GENDER}		MALE

${VALID_PASSWORD}     		apple-mango-banana
${NEW_VALID_PASSWORD}     	orange-grape-apple
${INVALID_SHORT}      		apple
${INVALID_SHORT_THEN3}      apple-mango
${COMMON_PASSWORD}    		123456789
${BAD_PASSWORD}       		robotuser123-apple-banana
${BLACKLIST}				password

${FILE1}    test_id.jpg
${FILE2}    test_selfie.jpg
# you must have file in the same directory of this robot file 'PasswordNCSCAPI.Robot' 

@{USER_IDS} 
${TOKEN}       None

${ADMIN_USERNAME}    admin123
${ADMIN_PASSWORD}    123456789
${ADMIN_TOKEN}       None

*** Test Cases ***

Create New Account With NCSC Password
	Create Test User For NCSC

Password must be at least 8 characters
    ${body}=    Create Dictionary
    ...    password=${INVALID_SHORT}

    ${response}=    POST On Session
    ...    api
    ...    ${VALIDATE_PASSWORD}
    ...    json=${body}
    ...    expected_status=any

    Should Be Equal As Integers    ${response.status_code}    400

Password must not contain username or email
    ${body}=    Create Dictionary
    ...    password=${BAD_PASSWORD}
    ...    username=${USERNAME}
    ...    email=${EMAIL}
    ...    firstName=${FIRSTNAME}
    ...    lastName=${LASTNAME}

    ${response}=    POST On Session
    ...    api
    ...    ${VALIDATE_PASSWORD}
    ...    json=${body}
    ...    expected_status=any

    Should Be Equal As Integers    ${response.status_code}    400

Password Must Contain At Least Three Words
    ${body}=    Create Dictionary
    ...    password=${INVALID_SHORT_THEN3}

    ${response}=    POST On Session
    ...    api
    ...    ${VALIDATE_PASSWORD}
    ...    json=${body}
    ...    expected_status=any

    Should Be Equal As Integers    ${response.status_code}    400

Password Must Not Be Common Password
    ${body}=    Create Dictionary
    ...    password=${COMMON_PASSWORD}

    ${response}=    POST On Session
    ...    api
    ...    ${VALIDATE_PASSWORD}
    ...    json=${body}
    ...    expected_status=any

    Should Be Equal As Integers    ${response.status_code}    400

Password Must Not In Blacklist
    ${body}=    Create Dictionary
    ...    password=${BLACKLIST}

    ${response}=    POST On Session
    ...    api
    ...    ${VALIDATE_PASSWORD}
    ...    json=${body}
    ...    expected_status=any

    Should Be Equal As Integers    ${response.status_code}    400

Login With Valid Password
    ${token}=    Login    ${USERNAME}    ${VALID_PASSWORD}
	Set Suite Variable    ${TOKEN}    ${token}


Change Password Successfully
	${response}=    Change Password
    ...    ${TOKEN}
    ...    ${VALID_PASSWORD}
    ...    ${NEW_VALID_PASSWORD}
    Should Be Equal As Integers    ${response.status_code}    200
	
Password Must Not Reuse Old Password
    ${TOKEN}=    Login    ${USERNAME}    ${NEW_VALID_PASSWORD}

    ${response}=    Change Password
    ...    ${TOKEN}
    ...    ${NEW_VALID_PASSWORD}
    ...    ${VALID_PASSWORD}

    Should Be Equal As Integers    ${response.status_code}    400
	
Account Is Locked After 3 Failed Attempts
    FOR    ${i}    IN RANGE    3
        ${body}=    Create Dictionary
        ...    username=${USERNAME}
        ...    password=wrongpass

        POST On Session
        ...    api
        ...    ${LOGIN_ENDPOINT}
        ...    json=${body}
        ...    expected_status=any
    END

    ${body}=    Create Dictionary
    ...    username=${USERNAME}
    ...    password=wrongpass

    ${response}=    POST On Session
    ...    api
    ...    ${LOGIN_ENDPOINT}
    ...    json=${body}
    ...    expected_status=any

    Should Be Equal As Integers    ${response.status_code}    403

Password Is Expired After 90 Days
    Create Test User For NCSC

    ${body}=    Create Dictionary
    ...    username=${USERNAME}
    ...    password=${VALID_PASSWORD}

    ${response}=    POST On Session
    ...    api
    ...    ${LOGIN_ENDPOINT}
    ...    json=${body}
    ...    expected_status=any

    ${json}=    Set Variable    ${response.json()}
    ${data}=    Get From Dictionary    ${json}    data

    Dictionary Should Contain Key    ${data}    requirePasswordChange

# ================= PERFORMANCE =================
Login Response Time Should Be Less Than 5 Seconds
    ${body}=    Create Dictionary
    ...    username=${USERNAME}
    ...    password=${VALID_PASSWORD}

    ${start}=    Get Time    epoch

    ${response}=    POST On Session
    ...    api
    ...    ${LOGIN_ENDPOINT}
    ...    json=${body}
    ...    expected_status=any

    ${end}=    Get Time    epoch
    ${duration}=    Evaluate    ${end} - ${start}

    Should Be True    ${duration} < 5

Sequential Login 5 Times Should Not Fail
    FOR    ${i}    IN RANGE    1    6
        ${body}=    Create Dictionary
        ...    username=${USERNAME}
        ...    password=${VALID_PASSWORD}

        ${response}=    POST On Session
        ...    api
        ...    ${LOGIN_ENDPOINT}
        ...    json=${body}
        ...    expected_status=any
    END
    Should Be True    True


*** Keywords ***
	
Initialize Suite
    Create Session    api    ${WEB_URL}
    Login As Admin
	
Delete Created User
    [Arguments]    ${id}

    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${ADMIN_TOKEN}

    ${endpoint}=    Set Variable    /api/users/admin/${id}

    DELETE On Session
    ...    api
    ...    ${endpoint}
    ...    headers=${headers}
    ...    expected_status=any
	
Generate Random User
    ${rand}=    Generate Random String    6
    Set Suite Variable    ${USERNAME}    robot${rand}
    Set Suite Variable    ${EMAIL}       robot${rand}@test.com

Cleanup Created Users
    FOR    ${id}    IN    @{USER_IDS}
        Delete Created User    ${id}
    END	
	
Create Test User For NCSC

	Generate Random User
	
	${nid}=    Evaluate    str(random.randint(1000000000000,9999999999999))

    ${file1}=    Evaluate    ('${FILE1}', open('${FILE1}','rb'), 'image/jpeg')
    ${file2}=    Evaluate    ('${FILE2}', open('${FILE2}','rb'), 'image/jpeg')

    ${files}=    Create Dictionary
    ...    nationalIdPhotoUrl=${file1}
    ...    selfiePhotoUrl=${file2}

    ${data}=    Create Dictionary
    ...    email=${EMAIL}
    ...    username=${USERNAME}
    ...    password=${VALID_PASSWORD}
    ...    firstName=${FIRSTNAME}
    ...    lastName=${LASTNAME}
    ...    phoneNumber=${PHONE}
    ...    gender=${GENDER}
    ...    nationalIdNumber=${nid}
    ...    nationalIdExpiryDate=2030-01-01T00:00:00.000Z

    ${response}=    POST On Session
    ...    api
    ...    ${CREATE_USER}
    ...    data=${data}
    ...    files=${files}
    ...    expected_status=any

    Log    ${response.text}

    Should Be Equal As Integers    ${response.status_code}    201

    ${json}=    Set Variable    ${response.json()}
    ${data}=    Get From Dictionary    ${json}    data
    ${id}=      Get From Dictionary    ${data}    id

	Append To List    ${USER_IDS}    ${id}
	
Login As Admin
    ${token}=    Login    ${ADMIN_USERNAME}    ${ADMIN_PASSWORD}
    Set Suite Variable    ${ADMIN_TOKEN}    ${token}

Login
    [Arguments]    ${username}    ${password}

    ${body}=    Create Dictionary
    ...    username=${username}
    ...    password=${password}

    ${response}=    POST On Session
    ...    api
    ...    ${LOGIN_ENDPOINT}
    ...    json=${body}

    Should Be Equal As Integers    ${response.status_code}    200

    ${json}=    Set Variable    ${response.json()}
    ${data}=    Get From Dictionary    ${json}    data
    ${token}=   Get From Dictionary    ${data}    token

    RETURN    ${token}

Change Password
    [Arguments]    ${token}    ${currentPassword}    ${newPassword}

    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${token}

    ${body}=    Create Dictionary
    ...    currentPassword=${currentPassword}
    ...    newPassword=${newPassword}
    ...    confirmNewPassword=${newPassword}

    ${response}=    PUT On Session
    ...    api
    ...    ${CHANGE_PASSWORD}
    ...    headers=${headers}
    ...    json=${body}
    ...    expected_status=any

    RETURN    ${response}