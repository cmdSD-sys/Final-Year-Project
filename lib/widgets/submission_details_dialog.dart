import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';

class SubmissionDetailsDialog extends StatelessWidget {
  final MonitoringSubmission submission;
  final VoidCallback onExport;

  const SubmissionDetailsDialog({
    super.key,
    required this.submission,
    required this.onExport,
  });

  static Future<void> show(
    BuildContext context, {
    required MonitoringSubmission submission,
    required VoidCallback onExport,
  }) {
    return showDialog(
      context: context,
      builder: (ctx) => SubmissionDetailsDialog(
        submission: submission,
        onExport: onExport,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dialogBg = Pal.of(context).surface;
    final cardBg = Pal.of(context).paper;
    final borderColor = Pal.of(context).rule;
    final textColor = Pal.of(context).ink;
    final subtextColor = Pal.of(context).inkMuted;

    return AlertDialog(
      backgroundColor: dialogBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: borderColor),
      ),
      title: Row(
        children: [
          Icon(
              Icons.assignment_outlined,
              color: isDark ? const Color(0xFF5DB8DB) : const Color(0xFF0B6A90),
              size: 22,
            ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Submission Details',
                  style: AppType.display(textColor, size: 22, height: 1.2),
                ),
                Text(
                  'ID: ${submission.id}',
                  style: TextStyle(
                    fontSize: 12,
                    color: subtextColor,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: 760,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Metadata Chips with height and horizontal separation
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _buildChip(
                    icon: Icons.school,
                    label: '${submission.programName} (${submission.programCode})',
                    isDark: isDark,
                  ),
                  _buildChip(
                    icon: Icons.calendar_today,
                    label: '${submission.semesterType} Semester',
                    isDark: isDark,
                  ),
                  _buildChip(
                    icon: Icons.verified_outlined,
                    label: 'NBA: ${submission.nbaStatus}',
                    isDark: isDark,
                  ),
                  _buildChip(
                    icon: Icons.access_time_filled_outlined,
                    label:
                        'Weeks Done: 1st Yr (${submission.weeksDoneYear1}w) • 2nd Yr (${submission.weeksDoneYear2}w) • 3rd Yr (${submission.weeksDoneYear3}w)',
                    isDark: isDark,
                  ),
                  _buildChip(
                    icon: Icons.event,
                    label:
                        DateFormat('dd MMM yyyy, hh:mm a').format(submission.submittedAt),
                    isDark: isDark,
                  ),
                  _buildChip(
                    icon: Icons.groups,
                    label: '${submission.rows.length} Faculty Entries',
                    isDark: isDark,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Faculty Entries (${submission.rows.length})',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: textColor,
                    ),
                  ),
                  Text(
                    'Internal Monitoring Rows',
                    style: TextStyle(
                      fontSize: 12,
                      color: subtextColor,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Faculty Rows List
              ...submission.rows.map((row) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: borderColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 12,
                            backgroundColor: isDark
                                ? const Color(0xFF0B6A90)
                                : const Color(0xFF1281B0),
                            child: Text(
                              '${row.srNo}',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              row.facultyName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.5,
                                color: textColor,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF1281B0).withValues(alpha: 0.2)
                                  : Color(0xFFE3F0F5),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: isDark
                                    ? const Color(0xFF2E93BD).withValues(alpha: 0.4)
                                    : Color(0xFFB5D9E8),
                              ),
                            ),
                            child: Text(
                              row.branchSemScheme,
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? const Color(0xFF9BD0E6)
                                    : Color(0xFF084E6B),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 12,
                        runSpacing: 6,
                        children: [
                          Text(
                            'Course: ${row.courseAbbreviationCode}',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? const Color(0xFF5DB8DB)
                                  : const Color(0xFF0B6A90),
                            ),
                          ),
                          Text(
                            'Qualification: ${row.qualification}',
                            style: TextStyle(
                              fontSize: 12.5,
                              color: subtextColor,
                            ),
                          ),
                          Text(
                            'Approval: ${row.facultyApproved}',
                            style: TextStyle(
                              fontSize: 12.5,
                              color: subtextColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          _buildMiniBadge('K1: ${row.k1}', isDark),
                          _buildMiniBadge('K2: ${row.k2}', isDark),
                          _buildMiniBadge('K3: ${row.k3}', isDark),
                          _buildMiniBadge('K6: ${row.k6}', isDark),
                          _buildMiniBadge('K7: ${row.k7}', isDark),
                          if (row.thPrescribed.isNotEmpty)
                            _buildMiniBadge(
                                'TH: ${row.thActual}/${row.thPrescribed}h', isDark),
                          if (row.prPrescribed.isNotEmpty)
                            _buildMiniBadge(
                                'PR: ${row.prActual}/${row.prPrescribed}h', isDark),
                          if (row.tuPrescribed.isNotEmpty)
                            _buildMiniBadge(
                                'TU: ${row.tuActual}/${row.tuPrescribed}h', isDark),
                        ],
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0B6A90),
            foregroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          ),
          onPressed: () {
            Navigator.pop(context);
            onExport();
          },
          icon: const Icon(Icons.download, size: 18),
          label: const Text('Export docx'),
        ),
      ],
    );
  }

  Widget _buildChip({
    required IconData icon,
    required String label,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0E222A) : const Color(0xFFE9EFF1),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: isDark ? const Color(0xFF2B4650) : const Color(0xFFC0CDD3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 15,
            color: isDark ? const Color(0xFF5DB8DB) : const Color(0xFF0B6A90),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDark ? const Color(0xFFD5DEE2) : const Color(0xFF14303A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniBadge(String text, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF14303A) : const Color(0xFFD5DEE2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: isDark ? const Color(0xFF8FA6AF) : const Color(0xFF44575F),
        ),
      ),
    );
  }
}
