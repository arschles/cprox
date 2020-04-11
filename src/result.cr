require "./option"

module Cprox
    class Result(T, U)
        def initialize(@val : T | U)
        end

        def self.with_nil(val : T)
            if val.nil?
                self.new Nil
            else
                self.new(val)
            end
        end

        # if the error is Ok, returns the value.
        # otherwise, raise the exception
        def or_raise(exception : Exception) : T
            if @val.is_a?(U)
                raise exception
            else
                @val
            end
        end
    
        # returns true if the Result is an error, 
        # false otherwise
        def is_err?() : Bool 
            if @val.is_a?(U)
                True
            else
                False
            end
        end

        # if the Result is an error, returns the error 
        # immediately. otherwise, call the block and
        # return a result with the new value in it
        def map(&block : T -> V) : Result(V, U) forall V
            if @val.is_a?(U)
                ret : Result(V, U) = self.as(Result(V, U))
                ret
            else
                to_call_with: T = @val.as(T)
                new_val : V | Nil = block.call(to_call_with)
                other_ret : Result(V, U) = Result.new(new_val)
                other_ret
            end
        end

        def flat_map(&block : T -> Result(V, U)) : Result(V, U) forall V
            if @val.is_a?(U)
                self
            else
                block.call(@val)
            end
        end
                

        # if this result is an error, return default.
        # if not, call block with the stored value
        # and return that
        def map_or(default : V, &block : T -> V) : V forall V
            if @val.is_a?(Exception)
                U
            else
                block.call(@val)
            end
        end

        # returns Some(T) if this Result is not an error,
        # otherwise, returns None
        def to_option() : Option(T)
            if @val.is_a?(Exception)
                None
            else
                Some.new(@val)
            end
        end

        def ok_or_nil() : T | Nil
            if @val.is_a?(T)
                @val
            else
                Nil
            end
        end

        def err_or_nil : U | Nil
            if @val.is_a?(T) 
                Nil
            else
                @val
            end
        end
    end
end