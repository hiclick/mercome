package com.mercome.activity.service;

public enum Function {
	createEvent(1001),
	updateEvent(1002),
	deleteEvent(1003),
	createLottery(2001),
	updateLottery(2002),
	deleteLottery(2003),
	createAward(3001),
	updateAward(3002),
	deleteAward(3003),
	changeAwardSeq(3004),
	createTasks(4001),
	createVote(5001),
	updateVote(5002),
	deleteVote(5003),
	changeVotes(5004),;

	Function(int value) {
		this.value = value;
	}

	private final int value;

	public int getValue() {
		return value;
	}
}
