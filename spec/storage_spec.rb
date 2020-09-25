RSpec.describe Tsks::Storage do
  describe ".init" do
    it "Creates the database table" do
      mock = instance_double(SQLite3::Database)
      allow(SQLite3::Database).to receive(:new).and_return mock
      expect(mock).to receive :execute
      described_class.init
    end
  end

  describe ".insert" do
    it "Inserts received tsk into the storage" do
      mock = instance_double(SQLite3::Database)
      allow(SQLite3::Database).to receive(:new).and_return mock
      expect(mock).to receive(:execute)
      described_class.insert "tsk"
    end

    it "Inserts received tsk with received context into the storage" do
      mock = instance_double(SQLite3::Database)
      allow(SQLite3::Database).to receive(:new).and_return mock
      expect(mock).to receive(:execute)
      described_class.insert "tsk", "ctx"
    end
  end

  describe ".update" do
    it "Updates the tsk with received id to be done" do
      mock = instance_double(SQLite3::Database)
      allow(SQLite3::Database).to receive(:new).and_return mock
      expect(mock).to receive :execute
      described_class.update 1
    end
  end

  describe ".select_by" do
    let(:raw_tsks) { [[1, 't', 'Work', 1, '0', '0']] }

    it "Returns all done tsks" do
      mock = instance_double(SQLite3::Database)
      allow(SQLite3::Database).to receive(:new).and_return(mock)
      expect(mock).to receive(:execute)
        .with("SELECT * FROM tsks WHERE done=?", 1).and_return(raw_tsks)
      described_class.select_by({done: 1})
    end

    it "Returns all tsks from storage with the received context" do
      mock = instance_double(SQLite3::Database)
      allow(SQLite3::Database).to receive(:new).and_return mock
      expect(mock).to receive(:execute)
        .with("SELECT * FROM tsks WHERE context=?", 'Work')
        .and_return(raw_tsks)
      described_class.select_by({context: "Work"})
    end

    it "Returns all done tsks from received context" do
      mock = instance_double(SQLite3::Database)
      allow(SQLite3::Database).to receive(:new).and_return(mock)
      expect(mock).to receive(:execute)
        .with("SELECT * FROM tsks WHERE done=? and context=?", [1, 'Work'])
        .and_return(raw_tsks)
      described_class.select_by({done: 1, context: "Work"})
    end

    it "Returns tsks structured as a hash" do
      mock = instance_double(SQLite3::Database)
      allow(SQLite3::Database).to receive(:new).and_return(mock)
      allow(mock).to receive(:execute).and_return(raw_tsks)
      result = described_class.select_by({done: 1})
      expect(result[0].instance_of? Hash).to be true
    end
  end
end
