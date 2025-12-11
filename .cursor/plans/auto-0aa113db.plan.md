<!-- 0aa113db-d387-42d5-9de2-b34cffc65c2d 122c8114-ef6c-4516-be57-68352fa029d3 -->
# License Header Polish

1. **Reference Asset Crop**  

- Identify the exact slice of `assets/DrivingLic.png` that contains the bilingual "Driving License" box + ministry labels so we can render only that strip (no generic black background).

2. **Header Layout Update**  

- Update/replace `LicenseHeaderCard` to use this cropped image as the dominant visual, remove the dark card background, and keep only the Driving License chip while aligning typography with the screenshot.

3. **Integrate & Verify**  

- Ensure `ReviewView` (and previews) show the refreshed header without leftover black boxes or gradients, and tweak spacing to blend with the rest of the screen.

### To-dos

- [ ] Capture identity + consent assumptions
- [ ] Describe Tawakkalna adapter service
- [ ] Explain client UI/data flow
- [ ] Plan audit trail exposure
- [ ] Verify bundled assets + crop needs
- [ ] Build LicenseHeaderCard view
- [ ] Place header in ReviewView
- [ ] Update mock profile name/photo
- [ ] Verify bundled assets + crop needs
- [ ] Build LicenseHeaderCard view
- [ ] Place header in ReviewView
- [ ] Update mock profile name/photo
- [ ] Capture identity + consent assumptions
- [ ] Describe Tawakkalna adapter service
- [ ] Explain client UI/data flow
- [ ] Plan audit trail exposure
- [ ] Verify helper loads Me.jpeg & DrivingLic.jpeg
- [ ] Show real portrait in UserProfileCard
- [ ] Add cropped driving-license header
- [ ] Determine DrivingLic.png crop slice
- [ ] Update LicenseHeaderCard to use cropped art
- [ ] Verify ReviewView uses new header