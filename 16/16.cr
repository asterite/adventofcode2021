enum TypeId
  Sum
  Product
  Minimum
  Maximum
  Literal
  GreaterThan
  LessThan
  EqualTo
end

record LiteralValue, version : Int32, value : Int64 do
  def to_s(io)
    io << value
  end
end

record OperatorPacket, version : Int32, type_id : TypeId, packets : Array(Packet) do
  def value : Int64
    case type_id
    in .sum?
      packets.sum(&.value)
    in .product?
      packets.product(&.value)
    in .minimum?
      packets.min_of(&.value)
    in .maximum?
      packets.max_of(&.value)
    in .literal?
      raise "Unexpected literal TypeId in operator packet"
    in .greater_than?
      binary_operator { |a, b| a > b }
    in .less_than?
      binary_operator { |a, b| a < b }
    in .equal_to?
      binary_operator { |a, b| a == b }
    end
  end

  def binary_operator : Int64
    if yield(packets[0].value, packets[1].value)
      1_i64
    else
      0_i64
    end
  end

  def to_s(io)
    case type_id
    in .sum?
      io << "sum("
      packets.join(io, ", ", &.to_s(io))
      io << ")"
    in .product?
      io << "product("
      packets.join(io, ", ", &.to_s(io))
      io << ")"
    in .minimum?
      io << "min("
      packets.join(io, ", ", &.to_s(io))
      io << ")"
    in .maximum?
      io << "max("
      packets.join(io, ", ", &.to_s(io))
      io << ")"
    in .literal?
      raise "Unexpected literal TypeId in operator packet"
    in .greater_than?
      io << "("
      packets[0].to_s(io)
      io << " > "
      packets[1].to_s(io)
      io << ")"
    in .less_than?
      io << "("
      packets[0].to_s(io)
      io << " < "
      packets[1].to_s(io)
      io << ")"
    in .equal_to?
      io << "("
      packets[0].to_s(io)
      io << " == "
      packets[1].to_s(io)
      io << ")"
    end
  end
end

alias Packet = LiteralValue | OperatorPacket

class Bits
  getter bits

  def initialize(@bits : Array(Int32))
  end

  def decode : Packet
    version = read_int(3)
    type_id = TypeId.new(read_int(3))

    if type_id.literal?
      read_literal_value(version)
    else
      read_operator_packet(version, type_id)
    end
  end

  def read_literal_value(version)
    LiteralValue.new(version: version, value: read_packet_value)
  end

  def read_operator_packet(version, type_id)
    length_type_id = read
    case length_type_id
    when 0
      read_operator_packet_0(version, type_id)
    when 1
      read_operator_packet_1(version, type_id)
    else
      raise "Unexpected length_type_id: #{length_type_id}"
    end
  end

  def read_operator_packet_0(version, type_id)
    length = read_int(15)

    packets = [] of Packet
    final_bit_count = bits.size - length
    until bits.size == final_bit_count
      packets << decode
    end

    OperatorPacket.new(
      version: version,
      type_id: type_id,
      packets: packets
    )
  end

  def read_operator_packet_1(version, type_id)
    packets_count = read_int(11)

    OperatorPacket.new(
      version: version,
      type_id: type_id,
      packets: Array.new(packets_count) do
        decode
      end
    )
  end

  def read_int(n)
    bits.shift(n).join.to_i(2)
  end

  def read
    bits.shift
  end

  def read_packet_value
    values = [] of Int64

    while true
      last_group = read == 0

      values << read_int(4).to_i64
      break if last_group
    end

    values.map(&.to_s(16)).join.to_i64(16)
  end
end

def version_sum(packet : LiteralValue)
  packet.version
end

def version_sum(packet : OperatorPacket)
  packet.version +
    packet.packets.sum { |sub_packet| version_sum(sub_packet) }
end

bits = File
  .read("#{__DIR__}/input.txt")
  .chomp
  .chars
  .flat_map { |char| char.to_i(16).to_s(2, precision: 4).chars }
  .map { |char| char == '1' ? 1 : 0 }

bits = Bits.new(bits)
packet = bits.decode

puts packet

part1 = version_sum(packet)
puts "Part 1: #{part1}"

part2 = packet.value
puts "Part 2: #{part2}"
