## code to prepare `.fields_regex` dataset goes here

.fields_regex <- c(
  # Line 1
  File_LabChart = c("(?<=File: \").+(?=\")"),
  Channel = c("(?<=Channel: ).+(?=Date)"),
  Date = c("(?<=Date: ).+"),
  # Line 2
  Start_time = c("(?<=Start time: ).+(?=End time)"),
  End_time = c("(?<=End time: ).+"),
  # Line 3
  Name = c("(?<=Name: )[:graph:]+"),
  Gender = c("(?<=Gender: )[:alpha:]+"),
  Age = c("(?<=Age: )([:digit:]|[:punct:])+"),
  # Line 4
  Beats_tot = c("(?<=Total number of beats = )([:digit:]|[:punct:])+"),
  Rec_length = c("(?<=Length of recording = )([:digit:]|[:punct:])+"),
  # Line 5
  Class_bound = c("(?<=Classification boundaries: ).+"),
  # Line 6
  Discontinuities = c("(?<=Discontinuities = )([:digit:]|[:punct:])+"),
  Beats_inserted = c("(?<=Manually inserted beats = )([:digit:]|[:punct:])+"),
  Beats_deleted = c("(?<=Manually deleted beats = )([:digit:]|[:punct:])+"),
  # Line 7
  NN_max = c("(?<=Maximum NN = )([:digit:]|[:punct:])+"),
  NN_min = c("(?<=Minimum NN = )([:digit:]|[:punct:])+"),
  NN_range = c("(?<=Range = )([:digit:]|[:punct:])+"),
  # Line 8
  NN_mean = c("(?<=Mean NN = )([:digit:]|[:punct:])+"),
  NN_median = c("(?<=Median NN = )([:digit:]|[:punct:])+"),
  HR_avg = c("(?<=Average heart rate = )([:digit:]|[:punct:])+"),
  # Line 9
  SDNN = c("(?<=SDNN = )([:digit:]|[:punct:])+"),
  SD_del_NN = c("(?<=SD of delta NN = )([:digit:]|[:punct:])+"),
  RMSSD = c("(?<=RMSSD = )([:digit:]|[:punct:])+"),
  # Line 10
  Normals_count = c("(?<=Normals = )([:digit:]|[:punct:])+"),
  Ectopics_count = c("(?<=Ectopics = )([:digit:]|[:punct:])+"),
  Artifacts_count = c("(?<=Artifacts = )([:digit:]|[:punct:])+"),
  NN50_count = c("(?<=NN50 = )([:digit:]|[:punct:])+"),
  # Line 11
  Spec_intv = c("(?<=Spectrum intervals = )([:digit:]|[:punct:])+"),
  Spec_mean_NN = c("(?<=Mean spectrum NN = )([:digit:]|[:punct:])+"),

  ## Extract after equal sign
  after_equal = c("(?<== )([:digit:]|[:punct:])+"),

  # Line 12
  Power_tot = c("(?<=Total power = )([:digit:]|[:punct:])+"),
  VLF_freq = c("(?<=VLF \\().+(?=\\))"),
  VLF = c("VLF \\(.+\\) = ([:digit:]|[:punct:])+"),
  # Last Line
  LF_freq = c("(?<=((?<!V)(LF) \\())[^\\)]+"),
  LF = c("(?<!V)(LF) \\(.+\\) = ([:digit:]|[:punct:])+"),
  LF_nu = c("(\\.|[:digit:])+(?=( nu\\)[:blank:]+HF))"),

  HF_freq = c("(?<=((HF) \\())[^\\)]+"),
  HF = c("(HF) \\(.+\\) = ([:digit:]|[:punct:])+"),
  HF_nu = c("(\\.|[:digit:])+(?=( nu\\)[:blank:]+LF/HF))"),

  LF_HF = c("(LF/HF) = ([:digit:]|[:punct:])+")

)


usethis::use_data(.fields_regex, overwrite = TRUE)
