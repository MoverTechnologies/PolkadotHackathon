export type CreateEventArgs = [string, string] & {
	moderator: string;
	agreementId: string;
};
export type CreateAgreementCallArgs = [
	string,
	string,
	number,
	number,
	number,
	number
] & {
	moderator: string;
	daoName: string;
	startTime: number;
	endTime: number;
	rewardAmount: number;
	vestingDuration: number;
};

export type UpdateAgreementCallArgs = [string, number, number, number] & {
	agreementId: string;
	startTime: number;
	endTime: number;
	rewardAmount: number;
};

export type CompleteAgreementCallArgs = [string, string] & {
	agreementId: string;
	review: string;
};
