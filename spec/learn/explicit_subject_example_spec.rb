RSpec.describe Array do
  subject(:sally) { [3, 5] }

  it 'caches the object within an example' do
    expect(subject.length).to eq(2)
    subject.pop
    expect(subject.length).to eq(1)
  end

  it 'creates a new object for a new example' do
    expect(sally).to eq([3, 5])
  end
end