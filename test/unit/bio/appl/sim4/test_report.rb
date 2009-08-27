#
# test/unit/bio/appl/sim4/test_report.rb - Unit test for Bio::Sim4
#
# Copyright::  Copyright (C) 2009
#              Naohisa Goto <ng@bioruby.org>
# License::    The Ruby License
#
#  $Id:$
#

require 'pathname'
libpath = Pathname.new(File.join(File.dirname(__FILE__), ['..'] * 5, 'lib')).cleanpath.to_s
$:.unshift(libpath) unless $:.include?(libpath)

require 'test/unit'
require 'bio/appl/sim4/report'

module Bio

  class TestDataForSim4Report
    bioruby_root = Pathname.new(File.join(File.dirname(__FILE__), ['..'] * 5)).cleanpath.to_s
    DataPath = Pathname.new(File.join(bioruby_root, 'test', 'data', 'sim4')).cleanpath.to_s

    def initialize(filename)
      @filename = filename
    end

    def read
      File.read(File.join(DataPath,@filename))
    end

    def report
      Bio::Sim4::Report.new(self.read)
    end

    def self.report(filename)
      self.new(filename).report
    end

    def self.report1
      filename = "simple-A4.sim4"
      self.new(filename).report
    end

    def self.report2
      filename = "simple2-A4.sim4"
      self.new(filename).report
    end

  end #class TestDataForSim4Report


  class TestSim4Report < Test::Unit::TestCase

    def setup
      @sim4 = TestDataForSim4Report.report1
    end

    def test_hits
      assert_kind_of(Array, @sim4.hits)
      assert_equal(1, @sim4.hits.size)
      assert_instance_of(Bio::Sim4::Report::Hit, @sim4.hits[0])
    end

    def test_all_hits
      assert_kind_of(Array, @sim4.all_hits)
      assert_equal(1, @sim4.all_hits.size)
      assert_instance_of(Bio::Sim4::Report::Hit, @sim4.all_hits[0])
    end

    def exec_test_seq1_len(sd)
      assert_equal(94, sd.len)
    end
    private :exec_test_seq1_len

    def test_seq1
      sd = @sim4.seq1
      assert_instance_of(Bio::Sim4::Report::SeqDesc, sd)
      assert_equal('mrna1', sd.entry_id)
      assert_equal('mrna1', sd.definition)
      assert_equal('sample10-1.fst', sd.filename)
      exec_test_seq1_len(sd)
    end

    def exec_test_each(meth)
      count = 0
      assert_nothing_raised {
        @sim4.__send__(meth) do |x|
          count += 1
        end
      }
      assert_equal(1, count)
      @sim4.__send__(meth) do |x|
        assert_instance_of(Bio::Sim4::Report::Hit, x)
      end
    end
    private :exec_test_each

    def test_each
      exec_test_each(:each)
    end

    def test_each_hit
      exec_test_each(:each_hit)
    end

    def test_num_hits
      assert_equal(1, @sim4.num_hits)
    end

    def test_query_def
      assert_equal('mrna1', @sim4.query_def)
    end

    def test_query_id
      assert_equal('mrna1', @sim4.query_id)
    end

    def test_query_len
      assert_equal(94, @sim4.query_len)
    end

  end #class TestSim4Report

  class TestSim4ReportHit < Test::Unit::TestCase

    def setup
      @hit = TestDataForSim4Report.report1.hits.first
    end

    def test_align
      a = [
           [ "TTGTTTCCGTCGCTGGTTATTGTCTAGAACGCAAAAATAG",
             "||||||||||||||||||||||||||||||||||||||||",
             "TTGTTTCCGTCGCTGGTTATTGTCTAGAACGCAAAAATAG" ],
           [ "         ",
             "<<<...<<<",
             "CTG...TAC" ],
           [ "TCTACACATCACTAGCGTGGGTGGGCGGAAAGAGCAGCTCGCCACT CAAGCTAA",
             "|||||||||||||||| |||||||||||||-|||||||||||||||-||||||||",
             "TCTACACATCACTAGCCTGGGTGGGCGGAA GAGCAGCTCGCCACTTCAAGCTAA" ]
          ]
      assert_equal(a, @hit.align)
    end

    def test_complement?
      assert_equal(nil, @hit.complement?)
    end

    def test_definition
      assert_equal('genome1', @hit.definition)
    end

    def test_each
      count = 0
      assert_nothing_raised {
        @hit.each do |x|
          count += 1
        end
      }
      assert_equal(2, count)
      @hit.each do |x|
        assert_instance_of(Bio::Sim4::Report::SegmentPair, x)
      end
    end

    def exec_test_exons(meth)
      assert_kind_of(Array, @hit.__send__(meth))
      assert_equal(2, @hit.__send__(meth).size)
      @hit.__send__(meth).each do |x|
        assert_instance_of(Bio::Sim4::Report::SegmentPair, x)
      end
    end
    private :exec_test_exons

    def test_exons
      exec_test_exons(:exons)
    end

    def test_hit_id
      assert_equal('genome1', @hit.hit_id)
    end

    def test_hsps
      exec_test_exons(:hsps)
    end

    def test_introns
      assert_kind_of(Array, @hit.introns)
      assert_equal(1, @hit.introns.size)
      @hit.introns.each do |x|
        assert_instance_of(Bio::Sim4::Report::SegmentPair, x)
      end
    end

    def test_len
      assert_equal(599, @hit.len)
    end

    def test_query_def
      assert_equal('mrna1', @hit.query_def)
    end

    def test_query_id
      assert_equal('mrna1', @hit.query_id)
    end

    def test_query_len
      assert_equal(94, @hit.query_len)
    end

    def test_segmentpairs
      assert_kind_of(Array, @hit.segmentpairs)
      assert_equal(3, @hit.segmentpairs.size)
      @hit.segmentpairs.each do |x|
        assert_instance_of(Bio::Sim4::Report::SegmentPair, x)
      end
    end

    def exec_test_seq1_len(sd)
      assert_equal(94, sd.len)
    end
    private :exec_test_seq1_len

    def test_seq1
      sd = @hit.seq1
      assert_instance_of(Bio::Sim4::Report::SeqDesc, sd)
      assert_equal('mrna1', sd.entry_id)
      assert_equal('mrna1', sd.definition)
      assert_equal('sample10-1.fst', sd.filename)
      exec_test_seq1_len(sd)
    end

    def test_seq2
      sd = @hit.seq2
      assert_instance_of(Bio::Sim4::Report::SeqDesc, sd)
      assert_equal('genome1', sd.entry_id)
      assert_equal('genome1', sd.definition)
      assert_equal(599, sd.len)
      #assert_equal('sample10-2.fst', sd.filename)
      assert_equal('sample10-2.fst (genome1)', sd.filename)
    end

    def test_target_def
      assert_equal('genome1', @hit.target_def)
    end

    def test_target_id
      assert_equal('genome1', @hit.target_id)
    end

    def test_target_len
      assert_equal(599, @hit.target_len)
    end
  end #class TestSim4ReportHit

  class TestSim4ReportSegmentPair_exon < Test::Unit::TestCase
    def setup
      @exon = TestDataForSim4Report.report1.hits[0].exons[1]
    end

    def test_align_len
      assert_equal(55, @exon.align_len)
    end

    def test_direction
      assert_equal("", @exon.direction)
    end

    def test_hit_from
      assert_equal(404, @exon.hit_from)
    end

    def test_hit_to
      assert_equal(457, @exon.hit_to)
    end

    def test_hseq
      hseq = "TCTACACATCACTAGCCTGGGTGGGCGGAA GAGCAGCTCGCCACTTCAAGCTAA"
      assert_equal(hseq, @exon.hseq)
    end

    def test_midline
      midline = "|||||||||||||||| |||||||||||||-|||||||||||||||-||||||||"
      assert_equal(midline, @exon.midline)
    end

    def test_percent_identity
      #assert_equal(94, @exon.percent_identity)
      assert_equal("94", @exon.percent_identity)
    end

    def test_qseq
      qseq = "TCTACACATCACTAGCGTGGGTGGGCGGAAAGAGCAGCTCGCCACT CAAGCTAA"
      assert_equal(qseq, @exon.qseq)
    end

    def test_query_from
      assert_equal(41, @exon.query_from)
    end

    def test_query_to
      assert_equal(94, @exon.query_to)
    end

    def exec_test_seq1_from_to(seg)
      assert_equal(41, seg.from)
      assert_equal(94, seg.to)
    end
    private :exec_test_seq1_from_to

    def test_seq1
      assert_instance_of(Bio::Sim4::Report::Segment, @exon.seq1)
      assert_equal("TCTACACATCACTAGCGTGGGTGGGCGGAAAGAGCAGCTCGCCACT CAAGCTAA",
                   @exon.seq1.seq)
      exec_test_seq1_from_to(@exon.seq1)
    end

    def test_seq2
      assert_instance_of(Bio::Sim4::Report::Segment, @exon.seq2)
      assert_equal(404, @exon.seq2.from)
      assert_equal(457, @exon.seq2.to)
      assert_equal("TCTACACATCACTAGCCTGGGTGGGCGGAA GAGCAGCTCGCCACTTCAAGCTAA",
                   @exon.seq2.seq)
    end
  end #class TestSim4ReportSegmentPair_exon

  class TestSim4ReportSegmentPair_intron < Test::Unit::TestCase
    def setup
      @intron = TestDataForSim4Report.report1.hits[0].introns[0]
    end

    def test_align_len
      assert_equal(9, @intron.align_len)
    end

    def test_direction
      assert_equal(nil, @intron.direction)
    end

    def test_hit_from
      assert_equal(185, @intron.hit_from)
    end

    def test_hit_to
      assert_equal(403, @intron.hit_to)
    end

    def test_hseq
      hseq = "CTG...TAC"
      assert_equal(hseq, @intron.hseq)
    end

    def test_midline
      midline = "<<<...<<<"
      assert_equal(midline, @intron.midline)
    end

    def test_percent_identity
      assert_equal(nil, @intron.percent_identity)
    end

    def test_qseq
      qseq = "         "
      assert_equal(qseq, @intron.qseq)
    end

    def test_query_from
      assert_equal(0, @intron.query_from)
    end

    def test_query_to
      assert_equal(0, @intron.query_to)
    end

    def test_seq1
      assert_instance_of(Bio::Sim4::Report::Segment, @intron.seq1)
      assert_equal(0, @intron.seq1.from)
      assert_equal(0, @intron.seq1.to)
      assert_equal("         ", @intron.seq1.seq)
    end

    def test_seq2
      assert_instance_of(Bio::Sim4::Report::Segment, @intron.seq2)
      assert_equal(185, @intron.seq2.from)
      assert_equal(403, @intron.seq2.to)
      assert_equal("CTG...TAC", @intron.seq2.seq)
    end
  end #class TestSim4ReportSegmentPair_intron


  class TestSim4Report2 < TestSim4Report
    def setup
      @sim4 = TestDataForSim4Report.report2
    end

    def test_query_len
      assert_equal(96, @sim4.query_len)
    end

    def exec_test_seq1_len(sd)
      assert_equal(96, sd.len)
    end
    private :exec_test_seq1_len
  end #class TestSim4Report2

  class TestSim4ReportHit2 < TestSim4ReportHit
    def setup
      @hit = TestDataForSim4Report.report2.hits.first
    end

    def test_align
      a = [
           [ "AGTTGTTTCCGTCGCTGGTTATTGTCTAGAACGCAAAAATAG",
             "||||||||||||||||||||||||||||||||||||||||||",
             "AGTTGTTTCCGTCGCTGGTTATTGTCTAGAACGCAAAAATAG" ],
           [ "         ",
             "<<<...<<<",
             "CTG...TAC" ],
           [ "TCTACACATCACTAGCGTGGGTGGGCGGAAAGAGCAGCTCGCCACT CAAGCTAA",
             "|||||||||||||||| |||||||||||||-|||||||||||||||-||||||||",
             "TCTACACATCACTAGCCTGGGTGGGCGGAA GAGCAGCTCGCCACTTCAAGCTAA" ]
          ]
      assert_equal(a, @hit.align)
    end

    def test_query_len
      assert_equal(96, @hit.query_len)
    end

    def exec_test_seq1_len(sd)
      assert_equal(96, sd.len)
    end
    private :exec_test_seq1_len
  end #class TestSim4ReportHit2


  class TestSim4ReportSegmentPair2_exon < TestSim4ReportSegmentPair_exon
    def setup
      @exon = TestDataForSim4Report.report2.hits[0].exons[1]
    end

    def test_query_from
      assert_equal(43, @exon.query_from)
    end

    def test_query_to
      assert_equal(96, @exon.query_to)
    end

    def exec_test_seq1_from_to(seg)
      assert_equal(43, seg.from)
      assert_equal(96, seg.to)
    end
    private :exec_test_seq1_from_to

  end #class TestSim4ReportSegmentPair2_exon


  class TestSim4ReportSegmentPair2_intron < TestSim4ReportSegmentPair_intron
    def setup
      @intron = TestDataForSim4Report.report2.hits[0].introns[0]
    end
  end #class TestSim4ReportSegmentPair2_intron


  class TestSim4ReportSeqDesc < Test::Unit::TestCase
    def setup
      @str1 = 'seq1 = c_NC_000011.5_101050001-101075000.fst, 25000 bp'
      @str2 = '>ref|NC_000011.5|NC_000011:c101075000-101050001 Homo sapiens chromosome 11, complete sequence'

      @seqdesc = Bio::Sim4::Report::SeqDesc.parse(@str1, @str2)
    end

    def test_entry_id
      assert_equal('ref|NC_000011.5|NC_000011:c101075000-101050001',
                   @seqdesc.entry_id)
    end

    def test_definition
      assert_equal("ref|NC_000011.5|NC_000011:c101075000-101050001 Homo sapiens chromosome 11, complete sequence",
                   @seqdesc.definition)
    end

    def test_len
      assert_equal(25000, @seqdesc.len)
    end

    def test_filename
      assert_equal('c_NC_000011.5_101050001-101075000.fst', @seqdesc.filename)
    end

    def test_self_parse
      assert_instance_of(Bio::Sim4::Report::SeqDesc,
                         Bio::Sim4::Report::SeqDesc.parse(@str1, @str2))

      assert_instance_of(Bio::Sim4::Report::SeqDesc,
                         Bio::Sim4::Report::SeqDesc.parse(@str1))
    end

    def test_self_new
      assert_instance_of(Bio::Sim4::Report::SeqDesc,
                         Bio::Sim4::Report::SeqDesc.new('SEQID',
                                                        'SEQDEF',
                                                        123,
                                                        'file.sim4'))
    end
  end #class TestSim4ReportSeqDesc


  class TestSim4ReportSegment < Test::Unit::TestCase
    def setup
      @seq = "TCTACACATCACTAGCGTGGGTGGGCGGAAAGAGCAGCTCGCCACT CAAGCTAA".freeze
      @segment = Bio::Sim4::Report::Segment.new("123", "176", @seq.dup)
    end

    def test_from
      assert_equal(123, @segment.from)
    end

    def test_to
      assert_equal(176, @segment.to)
    end

    def test_seq
      assert_equal(@seq, @segment.seq)
    end

    def test_self_new
      assert_instance_of(Bio::Sim4::Report::Segment,
                         Bio::Sim4::Report::Segment.new(1,9))
      assert_instance_of(Bio::Sim4::Report::Segment,
                         Bio::Sim4::Report::Segment.new(2,4, "ATG"))
    end
  end #class TestSim4ReportSegment

end #module Bio