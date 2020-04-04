class Option(T)
    def initialize(@var : T | Nil)
    end

    def map(block : T -> U) : Option(U)
        if @var.nil?
            return Option.new(nil)
        else
            Option.new(block(@var))
        end
    end
end

