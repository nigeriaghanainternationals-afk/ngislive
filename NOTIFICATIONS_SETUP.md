# NGIS: Offline mode and Parent Notifications - setup notes

## Offline mode (nothing to install)
1. Upload ALL files together (index.html AND sw.js) to your hosting. Open the app once with internet so the phone saves it.
2. Log in with internet at least once on each device. For offline sign-in, set up Fingerprint Login on that device (works for 30 days after the last online login).
3. While online, open the pages you will need offline (e.g. Enter Assessment for your class, week and subject, and the Class Register). Pages opened online are saved on the device.
4. With no network, keep working. Saves for assessments, mid-term, termly scores, class register, weekly comments etc. wait on the phone.
5. Tap the round network button (bottom-left) to see what is waiting. "Work offline" lets you switch to offline on a poor connection. When internet returns, changes are sent automatically (or press Sync now).

Limits: only score / attendance / comment saves work offline. Creating students, classes, deleting things, quizzes, etc. need internet. If two people edit the same score, the last one to sync wins.
On shared computers press "Clear offline data" in the network panel. Parent/student logins never save data on the device.

## Parent Notifications
1. Run `notifications_setup.sql` once in Supabase > SQL Editor.
2. Parent Notifications > Parent contacts: enter each family's phone/email once.
3. Send alert: choose Absent / Results published / Fees due / Announcement, check the message, Prepare recipients.
   - The WhatsApp / SMS / email buttons open your phone or computer with the message ready; you tap Send. Works immediately, no provider needed.
   - Absence alerts read the Class Register. Fees alerts use "Fees & Result Access". Publishing results offers to notify parents.
4. Notice board: notices appear at the top of the parent, teacher or admin dashboard.

## Optional: fully automatic sending (needs a developer and paid provider accounts)
`supabase_functions/send-notifications/index.ts` is an Edge Function that sends queued messages through Termii (SMS), Resend (email) and the WhatsApp Cloud API.
Deploy: `supabase functions deploy send-notifications`, then set secrets (see top of the file). WhatsApp business-initiated messages require a message template approved by Meta.
This function has NOT been tested with live accounts; send one test message first. Until it is deployed, "Send automatically" just leaves the messages queued in History.

## v10: Parent phone numbers, report cards to parents, automatic fingerprint
1. Run `v10_setup.sql` once in Supabase > SQL Editor (creates the `report-cards` storage bucket and the attachment link column).
2. Class teachers: menu > **Parent Phone Numbers**. Type each parent's number next to the child's name and press Submit. Numbers can be changed at any time. They are saved straight into Parent Notifications. The administrator sees progress per class on the same page.
3. Administrator / Management: Parent Notifications > **Send report cards**. Choose class, session, term (whole term or one week) and the types of report card, check the short message (it starts with the school name), press **Build report cards for parents**. The app makes one PDF per child, stores it, and prepares a message with the link.
   - **Send to all parents automatically** queues the messages for the server sender (Edge Function above). It needs the Termii / Resend / WhatsApp accounts.
   - Without those accounts, use the WhatsApp / SMS / email button on each row: one tap per family, message and link already filled in.
   - Do not use both methods for the same family.
   - The PDF is shared as a link (WhatsApp/SMS cannot attach files without a provider). With the WhatsApp Cloud API you can set the secret `WA_TEMPLATE_DOC` to a template with a document header and the PDF is attached to the chat; email sends it as an attachment.
4. Fingerprint: after a staff member logs in with a password once and accepts "Enable fingerprint", the fingerprint prompt appears by itself every time the app opens or after logout. Nothing needs to be pressed first. On some phones (iPhone) the first touch anywhere on the screen starts the prompt. The "Login with Fingerprint" button stays as a backup.

## Sending report cards (same way as Send alert)
Parent Notifications > Send report cards > choose class arm, term, weeks and report types > **Prepare report cards for all parents**.
The app builds each child's PDF and lists every parent with a WhatsApp button (message + school name + PDF link ready). Tap **Open next WhatsApp** or the button on each row, then tap Send in WhatsApp. No provider needed.
The paperclip button (on phones) shares the PDF file itself: pick WhatsApp, then the parent.
Sending by server (Termii / Resend / WhatsApp Cloud API) is optional and described above.

## v10b: CBT categories, fill-in Incident form and Lesson Observation form
Run `v10_setup.sql` again (safe to repeat): it adds the CBT category columns and the table that keeps submitted forms.
- CBT (teacher "Submit CBT Questions" and admin "CBT / Online Quiz"): new **CBT category** dropdown: CBT Weekly Assessment (pick a week, score goes to the weekly Test /10 as before), Termly Examination (pick term and session, score goes to the Exam column of the termly report card), JAMB Past Practices (practice only: no report-card score, students can retake). "Publish Results & Exam CBT" has the same three options.
- Incident & Concern Form (all staff) and Lesson Observation Form (HODs and admin): tap boxes, type text, Submit / Save. Drafts are kept on the device while typing. Saved forms are listed under the form; admin/management see all, teachers and HODs see their own. Print / PDF and Word downloads remain.
