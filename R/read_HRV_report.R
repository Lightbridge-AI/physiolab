#' Read LabChart's HRV Report Text file(s)
#'
#' Parse LabChart's HRV Report .txt files in to a tidy tibble with one row per file.
#' Internally, this function calls `readtext::readtext()` and use regular expression to extract
#' information from each variables.
#'
#' @param file path to .txt files to be read. This is designed to automagically handle a number of common scenarios, so the value can be a "glob"-type wildcard value.
#' @param ignore_missing_files if `FALSE`, then if the file argument doesn't resolve to an existing file, then an error will be thrown. Note that this can happen in a number of ways, including passing a path to a file that does not exist, to an empty archive file, or to a glob pattern that matches no files.
#' @param text_field,docid_field a variable (column) name or column number indicating where to find the texts that form the documents for the corpus and their identifiers. This must be specified for file types .csv, .json, and .xls/.xlsx files. For XML files, an XPath expression can be specified.
#' @param docvarsfrom used to specify that docvars should be taken from the filenames, when the readtext inputs are filenames and the elements of the filenames are document variables, separated by a delimiter (`dvsep`).
#'   This allows easy assignment of docvars from filenames such as 1789-Washington.txt, 1793-Washington, etc. by `dvsep` or from meta-data embedded in the text file header (headers). If docvarsfrom is set to "filepaths", consider the full path to the file, not just the filename.
#' @param dvsep separator (a regular expression character string) used in filenames to delimit docvar elements if `docvarsfrom="filenames"` or `docvarsfrom="filepaths"` is used
#' @param docvarnames character vector of variable names for `docvars`, if `docvarsfrom` is specified. If this argument is not used, default `docvar` names will be used (`docvar1`, `docvar2`, ...).
#' @param encoding vector: either the encoding of all files, or one encoding for each files
#' @param source used to specify specific formats of some input file types, such as JSON or HTML. Currently supported types are "twitter" for JSON and "nexis" for HTML
#' @param cache if TRUE, save remote file to a temporary folder. Only used when file is a URL.
#' @param format_cols If `TRUE` format appropriate output variables as factor, integer, or double. Compute `NN50_percent` (pNN50) from `NN50_count/Normals_count`
#' @param ... passed to `readtext::readtext()`
#'
#' @return A data.frame
#' @export
#'
#' @examples # read_HRV_report("path/to/folder")
read_HRV_report <- function(file,
                            ignore_missing_files = FALSE,
                            text_field = NULL,
                            docid_field = NULL,
                            docvarsfrom = c("metadata", "filenames", "filepaths"),
                            dvsep = "_",
                            docvarnames = NULL,
                            encoding = "UTF-16LE",
                            source = NULL,
                            cache = TRUE,
                            format_cols = TRUE,
                            ...
) {


  report_df  <- readtext::readtext(file = file,
                                   ignore_missing_files = ignore_missing_files,
                                   text_field = text_field,
                                   docid_field = docid_field,
                                   docvarsfrom = docvarsfrom,
                                   dvsep = dvsep,
                                   docvarnames = docvarnames,
                                   encoding = encoding,
                                   source = source,
                                   cache = cache,
                                   ...) %>%
    tibble::tibble() %>%
    dplyr::mutate(
      # Line 1
      File_LabChart = stringr::str_extract(text, .fields_regex[["File_LabChart"]]),
      Channel = stringr::str_extract(text, .fields_regex[["Channel"]]),
      Date = stringr::str_extract(text, .fields_regex[["Date"]]),
      # Line 2
      Start_time = stringr::str_extract(text, .fields_regex[["Start_time"]]),
      End_time = stringr::str_extract(text, .fields_regex[["End_time"]]),
      # Line 3
      Name = stringr::str_extract(text, .fields_regex[["Name"]]),
      Gender = stringr::str_extract(text, .fields_regex[["Gender"]]),
      Age = stringr::str_extract(text, .fields_regex[["Age"]]),
      # Line 4
      Beats_tot = stringr::str_extract(text, .fields_regex[["Beats_tot"]]),
      Rec_length = stringr::str_extract(text, .fields_regex[["Rec_length"]]),
      # Line 5
      Class_bound = stringr::str_extract(text, .fields_regex[["Class_bound"]]),
      # Line 6
      Discontinuities = stringr::str_extract(text, .fields_regex[["Discontinuities"]]),
      Beats_inserted = stringr::str_extract(text, .fields_regex[["Beats_inserted"]]),
      Beats_deleted = stringr::str_extract(text, .fields_regex[["Beats_deleted"]]),
      # Line 7
      NN_max = stringr::str_extract(text, .fields_regex[["NN_max"]]),
      NN_min = stringr::str_extract(text, .fields_regex[["NN_min"]]),
      NN_range = stringr::str_extract(text, .fields_regex[["NN_range"]]),
      # Line 8
      NN_mean = stringr::str_extract(text, .fields_regex[["NN_mean"]]),
      NN_median = stringr::str_extract(text, .fields_regex[["NN_median"]]),
      HR_avg = stringr::str_extract(text, .fields_regex[["HR_avg"]]),
      # Line 9
      SDNN = stringr::str_extract(text, .fields_regex[["SDNN"]]),
      SD_del_NN = stringr::str_extract(text, .fields_regex[["SD_del_NN"]]),
      RMSSD = stringr::str_extract(text, .fields_regex[["RMSSD"]]),
      # Line 10
      Normals_count = stringr::str_extract(text, .fields_regex[["Normals_count"]]),
      Ectopics_count = stringr::str_extract(text, .fields_regex[["Ectopics_count"]]),
      Artifacts_count = stringr::str_extract(text, .fields_regex[["Artifacts_count"]]),
      NN50_count = stringr::str_extract(text, .fields_regex[["NN50_count"]]),
      # Line 11
      Spec_intv = stringr::str_extract(text, .fields_regex[["Spec_intv"]]),
      Spec_mean_NN = stringr::str_extract(text, .fields_regex[["Spec_mean_NN"]]),
      # Line 12
      Power_tot = stringr::str_extract(text, .fields_regex[["Power_tot"]]),
      VLF_freq = stringr::str_extract(text, .fields_regex[["VLF_freq"]]),
      VLF = stringr::str_extract(text, .fields_regex[["VLF"]]) %>%
        stringr::str_extract(.fields_regex[["after_equal"]]),
      # Last line
      LF_freq = stringr::str_extract(text, .fields_regex[["LF_freq"]]),
      LF = stringr::str_extract(text, .fields_regex[["LF"]]) %>%
        stringr::str_extract(.fields_regex[["after_equal"]]),
      LF_nu = stringr::str_extract(text, .fields_regex[["LF_nu"]]),

      HF_freq = stringr::str_extract(text, .fields_regex[["HF_freq"]]),
      HF = stringr::str_extract(text, .fields_regex[["HF"]]) %>%
        stringr::str_extract(.fields_regex[["after_equal"]]),
      HF_nu = stringr::str_extract(text, .fields_regex[["HF_nu"]]),

      LF_HF = stringr::str_extract(text, .fields_regex[["LF_HF"]]) %>%
        stringr::str_extract(.fields_regex[["after_equal"]])
    ) %>%

    purrr::map_df(~stringr::str_trim(.x, side = "both"))

  if( !format_cols){ return(report_df) }

  ## Format column
  report_df %>%
    dplyr::mutate(dplyr::across(c(Channel, Gender), factor),
                  dplyr::across(Age, as.integer),
                  dplyr::across(c(Beats_tot,Rec_length, Discontinuities:Power_tot,
                                  VLF,LF, LF_nu, HF, HF_nu, LF_HF), as.numeric)
    ) %>%
    # Add pNN50
    dplyr::mutate(NN50_percent = 100 * (NN50_count/Normals_count), .after = NN50_count)

}
