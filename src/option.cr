module Cprox
    class Some(T)
        def initialize(@val : T) : Option(T)
            Option.new(@val)
        end
    end

    class None(T)
        def initialize(): Option(T)
            Option.new(Nil)
        end
    end

    class Option(T)
        def initialize(@val : T | Nil)
        end

        def zip(other : Option(U)) : Option(Tuple(T, U)) forall U
            other_val = -> {
                other.unwrap(Exception.new "shouldn't get here")
            }
            if @val.nil?
                Option.new(Nil).as Option(Tuple(T, U))
            elsif other.empty?
                Option.new(Nil).as Option(Tuple(T, U))
            else
                Option.new({
                    @val,
                    other_val.call
                }).as Option(Tuple(T, U))
            end
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

        def unwrap(ex : Exception)
            if @val.nil?
                raise ex
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

        def empty?
            return @val.nil?
        end
    end
end