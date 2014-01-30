trigger OB_PasscodeGen on Candidate__c (before update, before insert) {
    Candidate__c candidate = trigger.new[0];
	if (candidate.Passcode__c != 'XXX'){
	    candidate.Passcode__c = candidate.Email__c;
	    string salt = 'StJoApuytj2ih48p3062010';
	    Blob passcodeBlob = Blob.valueof(candidate.Email__c+salt);
	    Blob passcode = Crypto.generateDigest('MD5',passcodeBlob);
	    candidate.Passcode__c = EncodingUtil.base64Encode(passcode).substring(0, 12);
	}
}