package com.hair.salon.bean;

public class ResponseVo {
	public Boolean OpeSuccess;
	public String OpeMessage;
	public int Status;
	public String ReturnValue;
	public Object ExtraMessage;
	
	public Boolean getOpeSuccess() {
		return OpeSuccess;
	}

	public void setOpeSuccess(Boolean opeSuccess) {
		OpeSuccess = opeSuccess;
	}

	public String getOpeMessage() {
		return OpeMessage;
	}

	public void setOpeMessage(String opeMessage) {
		OpeMessage = opeMessage;
	}

	public int getStatus() {
		return Status;
	}

	public Object getExtraMessage() {
		return ExtraMessage;
	}

	public void setExtraMessage(Object extraMessage) {
		ExtraMessage = extraMessage;
	}

	public void setStatus(int status) {
		Status = status;
	}

	public String getReturnValue() {
		return ReturnValue;
	}

	public void setReturnValue(String returnValue) {
		ReturnValue = returnValue;
	}

}