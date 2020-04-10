module Cprox
    class Some(T)
        def initialize(@var : T) : Option(T)
            Option.new(@var)
        end
    end

    class None(T)
        def initialize(): Option(T)
            Option.new(Nil)
        end
    end

    class Option(T)
        def initialize(@var : T | Nil)
        end

        def map(&block: T -> U) : Option(U) forall U
            if @val.nil?
                return Option.new(Nil)
            else
                new_val: U = yield @val
                return Option.new(new_val)
            end
        end

        def unwrap_or(default : T): T
            if @val.nil?
                default
            else
                @val
            end
        end

        def if_full(&full: T -> U) forall U
            if @val.nil?
            else
                yield @val
            end
        end

        def if_nil(&empty: Nil -> U) forall U
            if @val.nil?
                yield
            end
        end
    end
end