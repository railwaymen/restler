**PROTOCOL**

# `RestlerDownloadRequestBuilderType`

## Methods
### `resumeData(_:)`

Sets resume data to the request to continue suspended download task.

- Parameters:
  - data: Data returned by cancelling a download request.

- Returns: `self` for chaining

### `requestDownload()`

Creates download request.

If you want to continue a previously cancelled request, provide the resume data using the `resumeData(_:)` function.
