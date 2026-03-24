Add-Type -AssemblyName System.Drawing
$SourceDir = [System.IO.Path]::Combine($PWD, "Assets\fotos")
$DestDir = [System.IO.Path]::Combine($PWD, "Assets\fotos\thumbs")

If (!(Test-Path $DestDir)) {
    New-Item -ItemType Directory -Force -Path $DestDir | Out-Null
}

$Files = @("2B8A3975.jpg", "2B8A4148.jpg", "2B8A4319.jpg", "2B8A4602.jpg", "2B8A4666.jpg")

foreach ($file in $Files) {
    try {
        $imgPath = [System.IO.Path]::Combine($SourceDir, $file)
        if (Test-Path $imgPath) {
            $img = [System.Drawing.Image]::FromFile($imgPath)
            $scale = 600.0 / $img.Width
            $newWidth = [math]::Round($img.Width * $scale)
            $newHeight = [math]::Round($img.Height * $scale)
            $bmp = New-Object System.Drawing.Bitmap($newWidth, $newHeight)
            $graph = [System.Drawing.Graphics]::FromImage($bmp)
            $graph.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
            $graph.DrawImage($img, 0, 0, $newWidth, $newHeight)
            $destPath = [System.IO.Path]::Combine($DestDir, $file)
            $bmp.Save($destPath, [System.Drawing.Imaging.ImageFormat]::Jpeg)
            $graph.Dispose()
            $bmp.Dispose()
            $img.Dispose()
            Write-Host "Processed file $file"
        }
    } catch {
        Write-Host "Error processing file $file"
    }
}
