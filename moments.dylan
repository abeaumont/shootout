module:         moments
synopsis:       implementation of "Statistical Moments" benchmark
author:         Peter Hinely
copyright:      public domain

// FIXME: this benchmark requires string-to-float, which is currently
// unavailable.

define library moments
  use common-dylan;
  use io;
end library;

define module moments
  use common-dylan, exclude: { format-to-string };
  use transcendentals;
  use format-out;
  use standard-io;
  use streams;
end module;


define constant <vector-of-doubles> = limited(<simple-vector>, of: <double-float>);


define function kth-smallest (a :: <vector-of-doubles>, k :: <integer>) => kth-smallest :: <double-float>;
  let L = 0;
  let R = A.size - 1;
  while (L < R)
     let X = A[K];
     let I = L;
     let J = R;
     until ((J < K) | (K < I))
       while (A[I] < X) I := I + 1; end;
       while (X < A[J]) J := J - 1; end;
       let W = A[I]; A[I] := A[J]; A[J] := W;
       I := I + 1; J := J - 1;
     end;
     if (J < K) L := I; end;
     if (K < I) R := J; end;
  end;
  a[k];
end; 


define function maximum (vec :: <vector-of-doubles>, limit :: <integer>) => res :: <double-float>;
  let current-max = vec[0];
  for (i from 1 below limit)
    if (vec[i] > current-max)
       current-max := vec[i];
    end;
  end;
  current-max;
end;


define function main () => ()
  let lines = make(<stretchy-vector>);

  let line = #f;
  while (line := read-line(*standard-input*, on-end-of-stream: #f))
    add!(lines, line);
  end;

  let nums = make(<vector-of-doubles>, size: lines.size, fill: 0.0);
  map-into(nums, string-to-float, lines);

  let sum = 0.0;

  // use a for loop instead of "reduce1" so "+" can be resolved.
  // To-do: test that this is really necessary after we fix all the other gf_calls
  for (num in nums)
    sum := sum + num;
  end;

  let n = nums.size;
  let mean = sum / n;
  let average-deviation = 0.0;
  let variance = 0.0;
  let skew = 0.0;
  let kurtosis = 0.0;

  for (num in nums)
    let deviation = num - mean;
    average-deviation := average-deviation + abs(deviation);
    variance := variance + (deviation ^ 2);
    skew := skew + (deviation ^ 3);
    kurtosis := kurtosis + (deviation ^ 4);
  end;

  average-deviation := average-deviation / n;
  variance := variance / (n - 1);
  let standard-deviation = sqrt(variance);

  if (variance > 0.0)
    skew := skew / (n * variance * standard-deviation);
    kurtosis := (kurtosis / (n * variance * variance)) - 3.0;
  end;

  let mid = floor/(n, 2);

  kth-smallest(nums, mid);

  let median = if (even?(n))
                 floor/(nums[mid] + maximum(nums, mid), 2);
               else
                 nums[mid];
               end;

  format-out("n:                  %d\n", n);
  format-out("median:             %=\n", median);
  format-out("mean:               %=\n", mean);
  format-out("average_deviation:  %=\n", average-deviation);
  format-out("standard_deviation: %=\n", standard-deviation);
  format-out("variance:           %=\n", variance);
  format-out("skew:               %=\n", skew);
  format-out("kurtosis:           %=\n", kurtosis);
end function;


main();