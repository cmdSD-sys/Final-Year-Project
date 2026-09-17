import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/models.dart';

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
    final dialogBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final cardBg = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final subtextColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    return AlertDialog(
      backgroundColor: dialogBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: borderColor),
      ),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF2563EB).withValues(alpha: 0.2)
                  : const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.assignment_outlined,
              color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF1E3A8A),
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Submission Details',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: textColor,
                  ),
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
                    borderRadius: BorderRadius.circular(12),
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
                                ? const Color(0xFF1E3A8A)
                                : const Color(0xFF2563EB),
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
                                  ? const Color(0xFF2563EB).withValues(alpha: 0.2)
                                  : Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: isDark
                                    ? const Color(0xFF3B82F6).withValues(alpha: 0.4)
                                    : Colors.blue.shade200,
                              ),
                            ),
                            child: Text(
                              row.branchSemScheme,
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? const Color(0xFF93C5FD)
                                    : Colors.blue.shade900,
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
                                  ? const Color(0xFF5EEAD4)
                                  : const Color(0xFF0F766E),
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
            backgroundColor: const Color(0xFF1E3A8A),
            foregroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
        color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 15,
            color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF1E3A8A),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF1E293B),
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
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
        ),
      ),
    );
  }
}
