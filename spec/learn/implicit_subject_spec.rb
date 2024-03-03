RSpec.describe Hash do
  it 'should start of empty' do
    expect(subject.length).to eq(0)
    subject[:key] = "Value"
    expect(subject.length).to eq(1)
  end

  it 'is isolated between examples' do
    expect(subject.length).to eq(0)
  end
end