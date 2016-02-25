require 'oystercard'

describe Oystercard do

  let(:station){ double :station }

  it 'has a balance of zero' do
    expect(subject.balance).to eq(0)
  end

  it 'can top up the balance' do
    expect{ subject.top_up 1 }.to change{ subject.balance }.by 1
  end

  it 'holds a log of all the journeys' do
    expect(subject.journeys).to be_empty
  end

  context 'balance is full' do

    before{ subject.top_up(Oystercard::BALANCE_LIMIT)}

      it 'raises an error of maximum is exceeded' do
        maximum_balance = Oystercard::BALANCE_LIMIT
        expect{ subject.top_up 1}.to raise_error "Cannot top up this amount!! Max limit = #{maximum_balance}"
      end

      it 'is initially not on a journey' do
        expect(subject).not_to be_in_journey
      end

      it 'can touch in' do
        subject.touch_in(station)
        expect(subject).to be_in_journey
      end

      it 'reduces the balance when touching out' do
        expect{ subject.touch_out(station) }.to change{ subject.balance }.by -Oystercard::MINIMUM_CHARGE
      end

      let(:entry_station) { double :station }
      let(:exit_station) { double :station }

      let(:journey){ {entry_station: entry_station, exit_station: exit_station} }

      it 'holds a journey' do
        subject.touch_in(entry_station)
        subject.touch_out(exit_station)
        expect(subject.journeys).to include journey
      end

      context 'card is in journey' do

        before{ subject.touch_in(station)}

        let(:entry_station) { double :station }
        let(:exit_station) { double :station }

        it 'can touch out' do
          subject.touch_out(station)
          expect(subject).not_to be_in_journey
        end

        it 'has recorded the entry station' do
          expect(subject.entry_station).to eq station
        end

        it 'records the exit station when touching out' do
          subject.touch_out(exit_station)
          expect(subject.exit_station).to eq exit_station
        end

      end

    end

  context 'card has insufficient balance' do

    it 'cannot touch in without enough balance' do
      expect{ subject.touch_in(station) }.to raise_error "Not enough money. Please top up."
    end

  end

end
