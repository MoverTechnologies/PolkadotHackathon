import { Agreement, Moderator } from '../types';
import {
	MoonbeamCall,
	MoonbeamEvent,
} from '@subql/contract-processors/dist/moonbeam';
import {
	CompleteAgreementCallArgs,
	CreateAgreementCallArgs,
	CreateEventArgs,
	UpdateAgreementCallArgs,
} from '../args';

export async function handleCreateAgreementEvent(
	event: MoonbeamEvent<CreateEventArgs>
): Promise<void> {
	const moderatorAddr = event.args.moderator;
	const agreementId = event.args.agreementId;

	const agreement = await Agreement.get(event.transactionHash);

	if (!agreement) {
		logger.error('Agreement not found');
		return;
	}
	agreement.agreementId = agreementId;

	agreement.save();

	const moderator = await getModerator(moderatorAddr);
	moderator.agreementIds.push(agreementId);

	moderator.save();
}

export const handleCreateAgreementCall = async (
	event: MoonbeamCall<CreateAgreementCallArgs>
) => {
	if (!event.success) {
		logger.warn('CreateAgreement Call was not successful');
		return;
	}

	const {
		moderator: moderatorAddr,
		daoName,
		startTime,
		endTime,
		rewardAmount,
		vestingDuration,
	} = event.args;
	const founder = event.from;

	const moderator = await getModerator(moderatorAddr);

	const agreement = await Agreement.create({
		id: event.hash,
		agreementId: '',
		moderatorId: moderator.id,
		founder,
		daoName,
		startTime: new Date(startTime * 1000),
		endTime: new Date(endTime * 1000),
		rewardAmount: BigInt(rewardAmount),
		vestingDuration: BigInt(vestingDuration),
		isCompleted: false,
	});

	agreement.save();
};

export const handleUpdateAgreementCall = async (
	event: MoonbeamCall<UpdateAgreementCallArgs>
) => {
	if (!event.success) {
		logger.error('UpdateAgreement Call was not successful');
		return;
	}

	const { agreementId, startTime, endTime, rewardAmount } = event.args;

	const agreement = await Agreement.getByAgreementId(agreementId);

	if (!agreement) {
		logger.error('Agreement not found');
		return;
	}

	if (startTime != 0) {
		agreement.startTime = new Date(startTime * 1000);
	}
	if (endTime != 0) {
		agreement.endTime = new Date(endTime * 1000);
	}
	if (rewardAmount != 0) {
		agreement.rewardAmount = BigInt(rewardAmount);
	}

	agreement.save();
};

export const handleCompleteAgreementCall = async (
	event: MoonbeamCall<CompleteAgreementCallArgs>
) => {
	if (!event.success) {
		logger.warn('CompleteAgreement Call was not successful');
		return;
	}

	const agreement = await Agreement.getByAgreementId(event.args.agreementId);

	if (!agreement) {
		logger.error('Agreement not found');
		return;
	}
	const moderator = await Moderator.get(agreement.moderatorId);

	if (!moderator) {
		logger.error('Moderator not found');
		return;
	}

	agreement.isCompleted = true;
	moderator.experiencedDaos++;

	await agreement.save();
	await moderator.save();
};

/**
 * @dev If moderator doesn't exist yet, creates new moderator and returns it
 * @param address moderator address
 * @returns moderator object
 */
export const getModerator = async (address: string): Promise<Moderator> => {
	const moderator = await Moderator.get(address);

	if (moderator) return moderator;

	const newModerator = await Moderator.create({
		id: address,
		experiencedDaos: 0,
		agreementIds: [],
	});
	await newModerator.save();

	return newModerator;
};
