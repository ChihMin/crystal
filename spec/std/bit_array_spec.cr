require "spec"
require "bit_array"

describe "BitArray" do
  it "has size" do
    ary = BitArray.new(100)
    ary.size.should eq(100)
  end

  it "is initially empty" do
    ary = BitArray.new(100)
    100.times do |i|
      ary[i].should be_false
    end
  end

  it "sets first bit to true" do
    ary = BitArray.new(100)
    ary[0] = true
    ary[0].should be_true
  end

  it "sets second bit to true" do
    ary = BitArray.new(100)
    ary[1] = true
    ary[1].should be_true
  end

  it "sets first bit to false" do
    ary = BitArray.new(100)
    ary[0] = true
    ary[0] = false
    ary[0].should be_false
  end

  it "sets second bit to false" do
    ary = BitArray.new(100)
    ary[1] = true
    ary[1] = false
    ary[1].should be_false
  end

  it "sets last bit to true with negative index" do
    ary = BitArray.new(100)
    ary[-1] = true
    ary[-1].should be_true
    ary[99].should be_true
  end

  it "toggles a bit" do
    ary = BitArray.new(32)
    ary[3].should be_false

    ary.toggle(3)
    ary[3].should be_true

    ary.toggle(3)
    ary[3].should be_false
  end

  it "inverts all bits" do
    ary = BitArray.new(100)
    ary.none?.should be_true

    ary.invert
    ary.all?.should be_true

    ary[50] = false
    ary[33] = false
    ary.count { |b| b }.should eq(98)

    ary.invert
    ary.count { |b| b }.should eq(2)
  end

  it "raises when out of bounds" do
    ary = BitArray.new(10)
    expect_raises IndexError do
      ary[10] = true
    end
  end

  it "does to_s" do
    ary = BitArray.new(8)
    ary[0] = true
    ary[2] = true
    ary[4] = true
    ary.to_s.should eq("BitArray[10101000]")
  end

  it "initializes with true by default" do
    ary = BitArray.new(64, true)
    ary.size.times { |i| ary[i].should be_true }
  end
end
