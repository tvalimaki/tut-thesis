% `tut-thesis.cls' provides a document class more or less compliant
% with the TUT thesis guidelines.
% Newest versions available under https://github.com/tvalimaki/tut-thesis
%
% Author: Tuomas Välimäki
%         tuomas.s.valimaki@tut.fi
%
% This file may be distributed and/or modified under the GNU Public License.
% http://www.gnu.org/licenses/gpl-3.0.en.html

\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{tut-thesis}[2016/04/07 Extension to basic LaTeX document class 'book']

% Declare class options
\RequirePackage{kvoptions}

\SetupKeyvalOptions{family=tl, prefix=tl@}
\DeclareStringOption[english]{main}
\ProcessKeyvalOptions*

\def\main@langu@ge{\tl@main}
\PassOptionsToPackage{main=\tl@main}{babel}

\DeclareOption{12pt}{\PassOptionsToClass{\CurrentOption}{book}}
\DeclareOption{a4paper}{\PassOptionsToClass{\CurrentOption}{book}}
\DeclareOption{oneside}{\PassOptionsToClass{\CurrentOption}{book}}

% Pass all unknown options to the base class
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{book}}

% Set defaults
\ExecuteOptions{12pt}
\ExecuteOptions{a4paper}
\ExecuteOptions{oneside}

\ProcessOptions\relax
% Load the basic template 'book.cls'. 
\LoadClass{book}

% Load required packages
\RequirePackage[T1]{fontenc} 	% proper font encoding for accented characters
\RequirePackage[utf8]{inputenc} % stop living in the medieval times and use utf8 input encoding
\RequirePackage[finnish,english]{babel} % translations and correct hyphenation
\RequirePackage[useregional,british]{datetime2}[2016/01/22] % make sure you also have v1.1 or newer of the datetime2-finnish language module
\RequirePackage[inner=4cm,outer=2cm,top=2.5cm,bottom=2.5cm]{geometry} % define page margins
\RequirePackage[labelsep=space,labelfont=bf,it,textfont=it]{caption} % figure and table captions
\RequirePackage[labelfont=up]{subcaption} % subfigure and subtable captions
\RequirePackage[scaled=0.8]{beramono} % better looking typewriter font
\RequirePackage[titletoc]{appendix} % appendix formatting
\RequirePackage{titlesec} 		% title formatting
\RequirePackage{fancyhdr} 		% header and footer formatting
\RequirePackage{parskip} 		% paragraph spacing that doesn't ruin TOC
\RequirePackage{etoolbox}		% tools to forking commands
\RequirePackage{setspace}		% provides line spacing
\RequirePackage{refcount} 		% reference handling
\RequirePackage[titles]{tocloft} % toc formatting
\RequirePackage[nostyles,nopostdot,nonumberlist,nogroupskip,xindy]{glossaries} % handles glossaries
\RequirePackage{ifthen}			% conditionals
\RequirePackage[hidelinks]{hyperref} % handles cross-referencing and produces hyperlinks
\RequirePackage{longtable} 		% tables that span multiple pages
\RequirePackage{tabu} 			% advanced tabular environment that provides e.g. automatic calculation of column widths
\RequirePackage{tikz}           % used to draw the TUT logo

%-----------------------------------------------------------------
% Define macros
%-----------------------------------------------------------------
\DeclareRobustCommand\title{\@ifnextchar[\@title@ii\@title@i}
\newcommand\@title@i[1]{\def\@title{#1}}
\newcommand\@title@ii[2][]{\def\@title{\iflanguage{\main@langu@ge}{#2}{#1}}}
\def\@title{\@latex@warning@no@line{No \noexpand\title given}}

\DeclareRobustCommand\thesistype{\@ifnextchar[\@thesistype@ii\@thesistype@i}
\newcommand\@thesistype@i[1]{\def\@thesistype{#1}}
\newcommand\@thesistype@ii[2][]{\def\@thesistype{\iflanguage{\main@langu@ge}{#2}{#1}}}
\def\@thesistype{\@latex@warning@no@line{No \noexpand\thesistype given}}

\DeclareRobustCommand\examiner{\@ifnextchar[\@examiner@ii\@examiner@i}
\newcommand\@examiner@i[1]{\def\@examiner{#1}}
\newcommand\@examiner@ii[2][]{\def\@examiner{\iflanguage{\main@langu@ge}{#2}{#1}}}
\def\@examiner{\@latex@warning@no@line{No \noexpand\examiner given}}

\DeclareRobustCommand\extrainfo{\@ifnextchar[\@extrainfo@ii\@extrainfo@i}
\newcommand\@extrainfo@i[1]{\def\@extrainfo{#1}}
\newcommand\@extrainfo@ii[2][]{\def\@extrainfo{\iflanguage{\main@langu@ge}{#2}{#1}}}
\def\@extrainfo{\@latex@warning@no@line{No \noexpand\extrainfo given}}

\DeclareRobustCommand\keywords{\@ifnextchar[\@keywords@ii\@keywords@i}
\newcommand\@keywords@i[1]{\def\@keywords{#1}}
\newcommand\@keywords@ii[2][]{\def\@keywords{\iflanguage{\main@langu@ge}{#2}{#1}}}
\def\@keywords{\@latex@warning@no@line{No \noexpand\keywords given}}

\DeclareRobustCommand\programme{\@ifnextchar[\@programme@ii\@programme@i}
\newcommand\@programme@i[1]{\def\@programme{#1}}
\newcommand\@programme@ii[2][]{\def\@programme{\iflanguage{\main@langu@ge}{#2}{#1}}}
\def\@programme{\@latex@warning@no@line{No \noexpand\programme given}}

\DeclareRobustCommand\major{\@ifnextchar[\@major@ii\@major@i}
\newcommand\@major@i[1]{\def\@major{#1}}
\newcommand\@major@ii[2][]{\def\@major{\iflanguage{\main@langu@ge}{#2}{#1}}}
\def\@major{\@latex@warning@no@line{No \noexpand\major given}}

\DeclareRobustCommand\location{\@ifnextchar[\@location@ii\@location@i}
\newcommand\@location@i[1]{\def\@location{#1}}
\newcommand\@location@ii[2][]{\def\@location{\iflanguage{\main@langu@ge}{#2}{#1}}}
\def\@location{\@latex@warning@no@line{No \noexpand\location given}}

\def\pagedifference#1#2{\number\numexpr\getpagerefnumber{#2}-\getpagerefnumber{#1}\relax}

\protected\def\and{\unskip, } % Oxford comma is the default
%\protected\def\and{} % this would disable the Oxford comma

\def\prnt@xmr#1\and#2\nil{%
  \edef\test{#2}%
  \ifx\test\@empty #1\else #1\expandafter\prnt@xmr@i#2\nil\fi%
}
\def\prnt@xmr@i#1\and#2\nil{%
  \edef\test{#2}%
  \ifx\test\@empty \examinersep\space#1\else \unskip, #1\expandafter\prnt@xmr@ii#2\nil\fi%
}
\def\prnt@xmr@ii#1\and#2\nil{%
  \edef\test{#2}%
  \ifx\test\@empty \and \examinersep\space#1\else \unskip, #1\expandafter\prnt@xmr@ii#2\nil\fi%
}
\def\tst@xmr#1\and#2\nil{%
  \edef\test{#2}%
  \ifx\test\@empty \examinername\else \examinernamepl\fi%
}
\newcommand\prntexaminer{%
  {%
  \iflanguage{finnish}{\protected\def\and{}}{}%
  \edef\names{\@examiner}%
  \expandafter\prnt@xmr\names\and\nil%
  }%
}
\newcommand\testexaminer{%
    \edef\names{\@examiner}%
    \expandafter\tst@xmr\names\and\nil%
}
\newcommand\printexaminer{\testexaminer: \prntexaminer}

%-----------------------------------------------------------------
% Define translations
%-----------------------------------------------------------------
\newcommand{\examinername}{%
  \@ifundefined{examinername@\languagename}%
    {Examiner}%
    {\@nameuse{examinername@\languagename}}%
}
\newcommand{\examinernamepl}{%
  \@ifundefined{examinernamepl@\languagename}%
    {Examiners}%
    {\@nameuse{examinernamepl@\languagename}}%
}
\newcommand{\examinersep}{%
  \@ifundefined{examinersep@\languagename}%
    {and}%
    {\@nameuse{examinersep@\languagename}}%
}
\newcommand{\universityname}{%
  \@ifundefined{universityname@\languagename}%
    {Tampere University of Technology}%
    {\@nameuse{universityname@\languagename}}%
}
\newcommand{\majorname}{%
  \@ifundefined{majorname@\languagename}%
    {Major}%
    {\@nameuse{majorname@\languagename}}%
}
\newcommand{\keywordsname}{%
  \@ifundefined{keywordsname@\languagename}%
    {Keywords}%
    {\@nameuse{keywordsname@\languagename}}%
}
\newcommand{\appendixp@gename}{%
  \@ifundefined{appendixp@gename@\languagename}%
    {Appendix page}%
    {\@nameuse{appendixp@gename@\languagename}}%
}
\newcommand{\appendixp@genamepl}{%
  \@ifundefined{appendixp@genamepl@\languagename}%
    {Appendix pages}%
    {\@nameuse{appendixp@genamepl@\languagename}}%
}
\newcommand{\pagesname}{%
  \@ifundefined{pagesname@\languagename}%
    {pages}%
    {\@nameuse{pagesname@\languagename}}%
}
\newcommand{\examinername@finnish}{Tarkastaja}
\newcommand{\examinernamepl@finnish}{\examinername@finnish t}
\newcommand{\examinersep@finnish}{ja}
\newcommand{\universityname@finnish}{Tampereen teknillinen yliopisto}
\newcommand{\majorname@finnish}{Pääaine}
\newcommand{\keywordsname@finnish}{Avainsanat}
\newcommand{\appendixp@gename@finnish}{liitesivu}
\newcommand{\appendixp@genamepl@finnish}{liitesivua}
\newcommand{\pagesname@finnish}{sivua}

\addto\captionsfinnish{%
  \renewcommand{\prefacename}{Alkusanat}%
  \renewcommand{\bibname}{Lähteet}%
  \renewcommand{\glossaryname}{Lyhenteet ja merkinnät}%
}
\addto\captionsenglish{%
  \renewcommand{\bibname}{References}%
  \renewcommand{\glossaryname}{List of symbols and abbreviations}%
}
\AtEndPreamble{%
\@ifpackageloaded{biblatex}{%
    \DefineBibliographyStrings{finnish}{%
      bibliography = {Lähteet},
      references = {Lähteet},
    }%
    \DefineBibliographyStrings{english}{%
      bibliography = {References},
      references = {References},
    }}{}
}

%-----------------------------------------------------------------
% TOC formatting
%-----------------------------------------------------------------
\AtBeginDocument{%
\let\oldcontentsline\contentsline
\def\contentsline#1#2{%
	\expandafter\ifx\csname l@#1\endcsname\l@chapter
		\expandafter\@firstoftwo
	\else
		\expandafter\@secondoftwo
	\fi
	{%
		\oldcontentsline{#1}{\MakeUppercase{#2}}%
	}{%
		\oldcontentsline{#1}{#2}%
	}%
}%
\setlength{\cftbeforechapskip}{0pt} % remove space before chapters
\renewcommand{\cftchapaftersnum}{.} % follow chapternumbers with a dot
\renewcommand{\cftchapfont}{\normalfont} % typeset entries with normalfont
\renewcommand{\cftchapleader}{\cftdotfill{\cftdotsep}} % use dots as leaders even for chapters
\renewcommand{\cftchappagefont}{\normalfont} % typeset pagenumber with normalfont
\setlength{\cftfigindent}{0pt} % don't indent figure list
\setlength{\cfttabindent}{0pt} % don't indent table list
}

% Remove space between table and figure caption entries between chapters
\let\oldlistoftables\listoftables
\def\listoftables{%
	\begingroup
	\renewcommand*{\addvspace}[1]{}
	\oldlistoftables
	\endgroup
}
\let\oldlistoffigures\listoffigures
\def\listoffigures{%
	\begingroup
	\renewcommand*{\addvspace}[1]{}
	\oldlistoffigures
	\endgroup
}
\AtBeginDocument{%
	\@ifundefined{listofalgorithms}{}{%
		\begingroup
			\let\newcounter\@gobble
			\let\setcounter\@gobbletwo
			\globaldefs\@ne
			\let\c@loadepth\@ne
			\newlistof{algorithms}{loa}{\listalgorithmname}
		\endgroup
		\let\l@algorithm\l@algorithms
		\setlength{\cftalgorithmsindent}{0pt} % don't indent algorithm list
		\setlength{\cftalgorithmsnumwidth}{\cftfignumwidth}

		\renewcommand{\thealgorithm}{\arabic{chapter}.\arabic{algorithm}}

		\let\oldlistofalgorithms\listofalgorithms
		\def\listofalgorithms{%
			\begingroup
			\renewcommand*{\addvspace}[1]{}
			\oldlistofalgorithms
			\endgroup
}}}

%-----------------------------------------------------------------
% Glossary formatting
%-----------------------------------------------------------------
\newlength{\glsentrywidth}
\setlength{\glsentrywidth}{6em}
\newglossarystyle{tut-thesis}{%
	\renewenvironment{theglossary}{%
  		\begingroup%
  		\setlength{\LTpre}{0pt}%
  		\setlength{\LTpost}{0pt}%
  		\tabulinesep=0.6ex%
  		\begin{longtabu} to \textwidth {@{}p{\glsentrywidth}X@{}}
  	}{%
  		\end{longtabu}
  		\endgroup
  	}
	\renewcommand*{\glossaryheader}{}
	\renewcommand*{\glsgroupheading}[1]{}
	\renewcommand{\glossentry}[2]{}
	\renewcommand{\subglossentry}[3]{%
    	\glsentryitem{##2}\glstarget{##2}{\glossentryname{##2}} &
    	\Glossentrydesc{##2}\glspostdescription\space ##3\tabularnewline}
	\renewcommand*{\glossaryentryfield}[5]{%
    	\glstarget{##1}{##2} & ##3\glspostdescription\space ##5\\}
	\renewcommand*{\glossarysubentryfield}[6]{%
    	\glstarget{##2}{##3} & ##4\glspostdescription\space ##6\\}
}

\setglossarystyle{tut-thesis}
\renewcommand{\glsglossarymark}[1]{\markboth{\MakeUppercase{#1}}{\MakeUppercase{#1}}}
\glsdisablehyper

%-----------------------------------------------------------------
% Document formatting
%-----------------------------------------------------------------
% PDF settings
\AtBeginDocument{%
\hypersetup{%
	pdfcreator = {\LaTeX{} with 'tut-thesis' package},
	bookmarksopen = true,
	bookmarksdepth = 2,% to show sections and subsections
	pdfauthor = {\@author},
	pdftitle = {\@title},
	pdfsubject = {\@thesistype},
	pdfkeywords = {\@keywords}}
}
% Set linespacing to 1.2
\setstretch{1.2}
% Allow pagebreaks for equations in align -environment
\allowdisplaybreaks 

% Alter some LaTeX defaults for better treatment of figures:
% See p.105 of "TeX Unbound" for suggested values.
% See pp. 199-200 of Lamport's "LaTeX" book for details.
%   General parameters, for ALL pages:
\renewcommand{\topfraction}{0.9}	% max fraction of floats at top
\renewcommand{\bottomfraction}{0.8}	% max fraction of floats at bottom
%   Parameters for TEXT pages (not float pages):
\setcounter{topnumber}{2} % max number of floats at top
\setcounter{bottomnumber}{2} % max number of float at bottom
\setcounter{totalnumber}{4}     % max number of float per any page
\setcounter{dbltopnumber}{2}    % for 2-column pages
\renewcommand{\dbltopfraction}{0.9}	% fit big float above 2-col. text
\renewcommand{\textfraction}{0.07}	% allow minimal text w. figs
%   Parameters for FLOAT pages (not text pages):
\renewcommand{\floatpagefraction}{0.7}	% require fuller float pages
% N.B.: floatpagefraction MUST be less than topfraction !!
\renewcommand{\dblfloatpagefraction}{0.7}	% require fuller float pages
% remember to use [htp] or [htpb] for placement
% setting the defaults to:
\renewcommand{\fps@figure}{htp}
\renewcommand{\fps@table}{htp}

% Titlepage
\renewcommand\maketitle{%
	\pagenumbering{gobble}%
	\begin{titlepage}%
	\null\vskip -.2cm%
    \insertlogo
	\vskip 6.8cm%
	\begingroup%
	\bf\large\sffamily%
	\MakeUppercase{\@author}\\%
	\MakeUppercase{\@title}%
	\endgroup%
	\vskip 12pt%
	\textsf{\@thesistype}%
	\vfill%
	\begin{flushright}%
		\begin{minipage}[t]{6.8cm}%
			\raggedright\sffamily%
			\begin{spacing}{1.0}%
				\printexaminer\\%
				\@extrainfo
			\end{spacing}%
		\end{minipage}%
	\end{flushright}%
	\vskip 1.5cm\null%
	\end{titlepage}%
}
% Abstract
\newlength{\miniparskip}
\setlength{\miniparskip}{\parskip}

\newenvironment{abstract}{%
	\chapter*{\abstractname}
	\sffamily
	\begin{spacing}{1.0}
		\raggedright
		\MakeUppercase{\universityname}\\
		\@programme\\
		\textbf{\MakeUppercase{\@author}}: \@title\\
		\@thesistype, \pages\\
        {%
          \DTMlangsetup*{showdayofmonth=false}
		  \@date\\
        }%
		\majorname: \@major\\
		\printexaminer\\
		\keywordsname: \@keywords
	\end{spacing}
	\normalfont
	\bigskip
	\begin{minipage}{\textwidth}
	\setlength{\parskip}{\miniparskip}
	\setstretch{1}
}{%
	\end{minipage}
}
% Preface
\newenvironment{preface}{%
    \chapter*{\prefacename}
}{%
    \vskip\bigskipamount
    \@location, \@date
    \vskip 2\bigskipamount
    \emph{\@author}
}
% Header and footer formatting
\pagestyle{fancy}
\renewcommand{\sectionmark}[1]{\markright{\thesection.\ #1}{}}
\renewcommand{\chaptermark}[1]{\markboth{\thechapter.\ \MakeUppercase{#1}}{}}
\fancyhf{}
\if@twoside%
	\rhead[\leftmark]{\thepage}
	\lhead[\thepage]{\rightmark}
\else
	\rhead[\rightmark]{\thepage}
	\lhead[\thepage]{\leftmark}
\fi
\fancypagestyle{plain}{%
	\fancyhf{}%
	\rhead[]{\thepage}%
	\lhead[\thepage]{}%
}
\renewcommand{\headrulewidth}{0pt}
\setlength\headheight{2.95ex}
\setlength\parskip{1.5ex plus 1ex minus .2ex}
% Titles for frontmatter
\appto\frontmatter{%
	\pagenumbering{gobble}%
	\titleformat{\chapter}[hang]%
		{\normalfont\sffamily\large\bfseries}%
		{\thechapter}{1em}{\MakeUppercase}%
	\titlespacing{\chapter}{0pt}{-1.8ex plus -1ex minus -.2ex}{1ex plus .2ex}%
}
% Start numbering at TOC
\appto\tableofcontents{%
	\pagenumbering{roman}%
}
% Titles for mainmatter
\appto\mainmatter{%
	\pagestyle{fancy}%
	\titleformat{\chapter}[hang]%
		{\normalfont\sffamily\Large\bfseries}%
		{\thechapter.}{1em}{\MakeUppercase}%
	\titleformat{\section}[hang]%
		{\normalfont\sffamily\large\bfseries}%
		{\thesection}{1em}{}%
	\titleformat{\subsection}[hang]%
		{\normalfont\sffamily\large\bfseries}%
		{\thesubsection}{1em}{}%
	\titlespacing{\chapter}{0pt}{*8}{*8}[2em]%
	\titlespacing{\section}{0pt}{*3}{*3}%
	\titlespacing{\subsection}{0pt}{*3}{*3}%
}
% Title for bibliography
\AtBeginDocument{%
	\let\oldprintbibliography\printbibliography
	\renewcommand\printbibliography[1][]{%
		\titleformat{\chapter}[hang]%
			{\normalfont\sffamily\large\bfseries}%
			{\thechapter}{1em}{\MakeUppercase}%
		\titlespacing{\chapter}{0pt}{-1.8ex plus -1ex minus -.2ex}{1ex plus .2ex}%
		\begingroup%
		\singlespacing%
		\setlength{\bibitemsep}{\parskip}%
		\oldprintbibliography[heading=bibintoc,#1]%
		\endgroup%
        \label{endcontent}%
	}%
    % a macro to calculate the number of pages in the document
    \newcommand{\pages}{% 
        \pageref*{endcontent}~\pagesname%
        \ifnum\pagedifference{endcontent}{endappendices}>0%
            \ifnum\pagedifference{endcontent}{endappendices}>1%
            , \pagedifference{endcontent}{endappendices}~\appendixp@genamepl%
            \else
            , 1~\appendixp@gename%
            \fi
        \fi}
}
\AtEndDocument{\label{endappendices}}
% Title and formatting for appendices
\AtBeginEnvironment{appendices}{%
	\titleformat{\chapter}[hang]%
		{\normalfont\sffamily\large\bfseries}%
		{\MakeUppercase{\appendixname} \thechapter:}{1em}{\MakeUppercase}%
	\titlespacing{\chapter}{0pt}{-1.8ex plus -1ex minus -.2ex}{1ex plus .2ex}%
	\addtocontents{toc}{\bigskip\cftpagenumbersoff{chapter}}%
	\let\oldchapter\chapter%
	\def\chapter#1{\oldchapter{#1}\thispagestyle{empty}\pagestyle{empty}}%
}
\AtEndEnvironment{appendices}{\thispagestyle{empty}\pagestyle{empty}}

%-----------------------------------------------------------------
% Define TUT logo as a TikZ image
%-----------------------------------------------------------------
\newcommand{\insertlogo}{%
\begin{tikzpicture}[y=1pt, x=1pt, yscale=1, xscale=1, inner sep=0pt, outer sep=0pt]
\begin{scope}[cm={{0.08524,0.0,0.0,0.08524,(19.63918,2.92944)}}]%
    \path[fill,nonzero rule] (505.3440,163.9920) -- (519.3480,163.9920) --
    (519.3480,229.3050) -- (537.0900,229.3050) -- (537.0900,237.7460) --
    (487.5980,237.7460) -- (487.5980,229.3050) -- (505.3440,229.3050) --
    (505.3440,163.9920);

    \path[fill,nonzero rule] (546.5470,163.9920) -- (558.9490,163.9920) --
    (565.5780,184.9410) -- (590.6990,184.9410) -- (597.1090,163.9920) --
    (611.9690,163.9920) -- (586.3160,237.7460) -- (571.9880,237.7460) --
    (546.5470,163.9920) -- (546.5470,163.9920) -- cycle(578.1880,225.3440) --
    (578.4020,225.3440) -- (588.3440,192.7460) -- (568.0310,192.7460) --
    (578.1880,225.3440) -- (578.1880,225.3440);

    \path[fill,nonzero rule] (631.3670,163.9920) -- (641.7340,163.9920) --
    (641.7340,225.6640) -- (641.9490,225.6640) -- (663.6480,163.9920) --
    (674.3400,163.9920) -- (696.0350,227.1640) -- (696.2500,227.1640) --
    (696.2500,163.9920) -- (708.6520,163.9920) -- (708.6520,237.7460) --
    (690.9020,237.7460) -- (670.1680,177.5700) -- (669.9530,177.5700) --
    (648.6840,237.7460) -- (631.3670,237.7460) -- (631.3670,163.9920);

    \path[fill,nonzero rule] (735.9570,163.9920) -- (749.9610,163.9920) --
    (749.9610,196.0630) -- (753.4920,196.0630) .. controls (765.1370,196.0630) and
    (782.7770,197.7700) .. (782.7770,217.3320) .. controls (782.7770,234.3280) and
    (770.5980,237.7460) .. (753.4920,237.7460) -- (735.9570,237.7460) --
    (735.9570,163.9920) -- cycle(749.9610,229.9410) -- (753.4920,229.9410) ..
    controls (763.4300,229.9410) and (768.7810,227.6950) .. (768.7810,217.4340) ..
    controls (768.7810,205.5740) and (761.5040,203.8630) .. (753.4920,203.8630) --
    (749.9610,203.8630) -- (749.9610,229.9410);

    \path[fill,nonzero rule] (802.8050,163.9920) -- (846.8480,163.9920) --
    (846.8480,172.8670) -- (816.8010,172.8670) -- (816.8010,198.1990) --
    (844.3870,198.1990) -- (844.3870,206.6370) -- (816.8010,206.6370) --
    (816.8010,229.3050) -- (845.8830,229.3050) -- (845.8830,237.7460) --
    (802.8050,237.7460) -- (802.8050,163.9920);

    \path[fill,nonzero rule] (869.8590,163.9920) -- (883.8630,163.9920) --
    (883.8630,196.2700) -- (888.2460,196.2700) .. controls (899.2540,196.2700) and
    (901.2850,191.3590) .. (903.9610,177.8910) -- (906.6330,163.9920) --
    (920.6370,163.9920) -- (916.4650,183.5510) .. controls (914.6450,192.1050) and
    (913.1560,199.1560) .. (902.2500,201.1880) -- (902.2500,201.4020) .. controls
    (908.8790,203.1170) and (917.6370,207.0660) .. (917.6370,218.5040) .. controls
    (917.6370,235.2850) and (902.9920,237.7460) .. (886.6410,237.7460) --
    (869.8590,237.7460) -- (869.8590,163.9920) -- cycle(883.8630,229.9410) --
    (886.6410,229.9410) .. controls (895.2970,229.9410) and (903.6370,229.1950) ..
    (903.6370,217.4340) .. controls (903.6370,206.6370) and (896.5820,204.0780) ..
    (886.6410,204.0780) -- (883.8630,204.0780) -- (883.8630,229.9410);

    \path[fill,nonzero rule] (942.6990,163.9920) -- (986.7500,163.9920) --
    (986.7500,172.8670) -- (956.7110,172.8670) -- (956.7110,198.1990) --
    (984.2890,198.1990) -- (984.2890,206.6370) -- (956.7110,206.6370) --
    (956.7110,229.3050) -- (985.7930,229.3050) -- (985.7930,237.7460) --
    (942.6990,237.7460) -- (942.6990,163.9920);

    \path[fill,nonzero rule] (1105.4900,237.7460) -- (1091.4800,237.7460) --
    (1091.4800,189.1170) .. controls (1091.4800,177.5700) and (1089.9900,169.8750)
    .. (1078.6600,169.8750) .. controls (1067.9700,169.8750) and
    (1066.1500,177.5700) .. (1066.1500,189.1170) -- (1066.1500,237.7460) --
    (1052.1500,237.7460) -- (1052.1500,189.1170) .. controls (1052.1500,175.9690)
    and (1054.9200,162.8240) .. (1078.6600,162.8240) .. controls
    (1102.7100,162.8240) and (1105.4900,175.9690) .. (1105.4900,189.1170) --
    (1105.4900,237.7460);

    \path[fill,nonzero rule] (1131.8400,163.9920) -- (1143.2700,163.9920) --
    (1143.2700,221.3950) -- (1143.5000,221.3950) -- (1173.4200,163.9920) --
    (1187.3200,163.9920) -- (1187.3200,237.7460) -- (1175.8800,237.7460) --
    (1175.8800,183.0200) -- (1175.6700,183.0200) -- (1147.1300,237.7460) --
    (1131.8400,237.7460) -- (1131.8400,163.9920);

    \path[fill,nonzero rule] (1214.5400,163.9920) -- (1228.5500,163.9920) --
    (1228.5500,237.7460) -- (1214.5400,237.7460) -- (1214.5400,163.9920);

    \path[fill,nonzero rule] (1271.2300,163.9920) -- (1285.6600,163.9920) --
    (1311.2100,237.7460) -- (1298.8100,237.7460) -- (1279.6700,180.8870) --
    (1279.4600,180.8870) -- (1260.6500,237.7460) -- (1246.1100,237.7460) --
    (1271.2300,163.9920) -- (1271.2300,163.9920);

    \path[fill,nonzero rule] (1328.6800,163.9920) -- (1372.7300,163.9920) --
    (1372.7300,172.8670) -- (1342.6900,172.8670) -- (1342.6900,198.1990) --
    (1370.2700,198.1990) -- (1370.2700,206.6370) -- (1342.6900,206.6370) --
    (1342.6900,229.3050) -- (1371.7600,229.3050) -- (1371.7600,237.7460) --
    (1328.6800,237.7460) -- (1328.6800,163.9920);

    \path[fill,nonzero rule] (1395.7400,163.9920) -- (1409.7400,163.9920) --
    (1409.7400,196.2700) -- (1414.1300,196.2700) .. controls (1425.1400,196.2700)
    and (1427.1700,191.3590) .. (1429.8400,177.8910) -- (1432.5100,163.9920) --
    (1446.5200,163.9920) -- (1442.3500,183.5510) .. controls (1440.5300,192.1050)
    and (1439.0300,199.1560) .. (1428.1400,201.1880) -- (1428.1400,201.4020) ..
    controls (1434.7500,203.1170) and (1443.5300,207.0660) .. (1443.5300,218.5040)
    .. controls (1443.5300,235.2850) and (1428.8800,237.7460) ..
    (1412.5200,237.7460) -- (1395.7400,237.7460) -- (1395.7400,163.9920) --
    cycle(1409.7400,229.9410) -- (1412.5200,229.9410) .. controls
    (1421.1800,229.9410) and (1429.5200,229.1950) .. (1429.5200,217.4340) ..
    controls (1429.5200,206.6370) and (1422.4600,204.0780) .. (1412.5200,204.0780)
    -- (1409.7400,204.0780) -- (1409.7400,229.9410);

    \path[fill,nonzero rule] (1507.8200,236.8910) .. controls
    (1505.0400,237.4300) and (1497.2300,238.9220) .. (1489.4300,238.9220) ..
    controls (1473.5000,238.9220) and (1464.5200,231.7580) .. (1464.5200,219.8980)
    .. controls (1464.5200,196.5980) and (1499.4800,196.9220) ..
    (1499.4800,180.2420) .. controls (1499.4800,173.2930) and (1492.6400,171.2620)
    .. (1487.9300,171.2620) .. controls (1479.6000,171.2620) and
    (1471.3700,175.6450) .. (1465.7000,179.1720) -- (1465.7000,166.1330) ..
    controls (1468.3800,165.3870) and (1476.8200,162.8240) .. (1485.6900,162.8240)
    .. controls (1501.5100,162.8240) and (1513.4800,168.6990) ..
    (1513.4800,184.7340) .. controls (1513.4800,207.6050) and (1477.4600,208.4570)
    .. (1477.4600,222.8870) .. controls (1477.4600,227.4880) and
    (1481.6300,230.4800) .. (1487.5000,230.4800) .. controls (1496.0500,230.4800)
    and (1505.2500,226.7340) .. (1507.8200,225.4490) -- (1507.8200,236.8910);

    \path[fill,nonzero rule] (1535.5300,163.9920) -- (1549.5400,163.9920) --
    (1549.5400,237.7460) -- (1535.5300,237.7460) -- (1535.5300,163.9920);

    \path[fill,nonzero rule] (1586.6700,163.9920) -- (1600.6700,163.9920) --
    (1600.6700,229.3050) -- (1618.4100,229.3050) -- (1618.4100,237.7460) --
    (1568.9200,237.7460) -- (1568.9200,229.3050) -- (1586.6700,229.3050) --
    (1586.6700,163.9920);

    \path[fill,nonzero rule] (1651.0700,163.9920) -- (1665.0700,163.9920) --
    (1665.0700,198.5160) -- (1689.2300,237.7460) -- (1675.7600,237.7460) --
    (1659.7200,210.7030) -- (1644.2200,237.7460) -- (1628.0900,237.7460) --
    (1651.0700,198.5160) -- (1651.0700,163.9920);

    \path[fill,nonzero rule] (1777.8300,162.8240) .. controls
    (1799.4300,162.8240) and (1808.6200,178.3160) .. (1808.6200,200.8710) ..
    controls (1808.6200,223.4260) and (1799.4300,238.9220) .. (1777.8300,238.9220)
    .. controls (1756.1300,238.9220) and (1747.0400,223.4260) ..
    (1747.0400,200.8710) .. controls (1747.0400,178.3160) and (1756.1300,162.8240)
    .. (1777.8300,162.8240) -- (1777.8300,162.8240) -- cycle(1761.8000,200.8710)
    .. controls (1761.8000,219.4690) and (1766.1800,231.8670) ..
    (1777.8300,231.8670) .. controls (1789.4800,231.8670) and (1793.8700,219.4690)
    .. (1793.8700,200.8710) .. controls (1793.8700,182.2730) and
    (1789.4800,169.8750) .. (1777.8300,169.8750) .. controls (1766.1800,169.8750)
    and (1761.8000,182.2730) .. (1761.8000,200.8710) -- (1761.8000,200.8710);

    \path[fill,nonzero rule] (1832.7300,163.9920) -- (1846.7400,163.9920) --
    (1846.7400,198.1990) -- (1872.9300,198.1990) -- (1872.9300,206.6370) --
    (1846.7400,206.6370) -- (1846.7400,229.3050) -- (1874.4300,229.3050) --
    (1874.4300,237.7460) -- (1832.7300,237.7460) -- (1832.7300,163.9920);

    \path[fill,nonzero rule] (1948.9300,163.9920) -- (1962.9400,163.9920) --
    (1962.9400,229.3050) -- (1980.6800,229.3050) -- (1980.6800,237.7460) --
    (1931.1900,237.7460) -- (1931.1900,229.3050) -- (1948.9300,229.3050) --
    (1948.9300,163.9920);

    \path[fill,nonzero rule] (1999.9700,163.9920) -- (2044.0200,163.9920) --
    (2044.0200,172.8670) -- (2013.9800,172.8670) -- (2013.9800,198.1990) --
    (2041.5500,198.1990) -- (2041.5500,206.6370) -- (2013.9800,206.6370) --
    (2013.9800,229.3050) -- (2043.0500,229.3050) -- (2043.0500,237.7460) --
    (1999.9700,237.7460) -- (1999.9700,163.9920);

    \path[fill,nonzero rule] (2116.9500,178.9570) .. controls
    (2114.2700,176.9260) and (2107.9700,171.6910) .. (2098.6700,171.6910) ..
    controls (2079.0000,171.6910) and (2078.6800,196.0630) .. (2078.6800,204.6090)
    .. controls (2078.6800,214.4490) and (2080.8200,231.8670) ..
    (2093.2200,231.8670) .. controls (2102.2000,231.8670) and (2104.0200,223.4260)
    .. (2104.0200,217.6520) -- (2119.9400,217.6520) .. controls
    (2119.9400,230.5820) and (2111.4900,238.9220) .. (2094.0800,238.9220) ..
    controls (2071.7300,238.9220) and (2063.9300,221.8160) .. (2063.9300,202.2580)
    .. controls (2063.9300,181.4180) and (2072.8000,162.8240) ..
    (2096.1100,162.8240) .. controls (2104.9800,162.8240) and (2112.2400,165.5980)
    .. (2116.9500,167.4140) -- (2116.9500,178.9570);

    \path[fill,nonzero rule] (2139.9800,163.9920) -- (2153.9800,163.9920) --
    (2153.9800,198.4140) -- (2179.6400,198.4140) -- (2179.6400,163.9920) --
    (2193.6400,163.9920) -- (2193.6400,237.7460) -- (2179.6400,237.7460) --
    (2179.6400,206.8550) -- (2153.9800,206.8550) -- (2153.9800,237.7460) --
    (2139.9800,237.7460) -- (2139.9800,163.9920);

    \path[fill,nonzero rule] (2220.8500,163.9920) -- (2232.2900,163.9920) --
    (2232.2900,221.3950) -- (2232.5000,221.3950) -- (2262.4400,163.9920) --
    (2276.3400,163.9920) -- (2276.3400,237.7460) -- (2264.9000,237.7460) --
    (2264.9000,183.0200) -- (2264.6900,183.0200) -- (2236.1400,237.7460) --
    (2220.8500,237.7460) -- (2220.8500,163.9920);

    \path[fill,nonzero rule] (2331.4600,162.8240) .. controls
    (2353.0500,162.8240) and (2362.2400,178.3160) .. (2362.2400,200.8710) ..
    controls (2362.2400,223.4260) and (2353.0500,238.9220) .. (2331.4600,238.9220)
    .. controls (2309.7600,238.9220) and (2300.6700,223.4260) ..
    (2300.6700,200.8710) .. controls (2300.6700,178.3160) and (2309.7600,162.8240)
    .. (2331.4600,162.8240) -- (2331.4600,162.8240) -- cycle(2315.4200,200.8710)
    .. controls (2315.4200,219.4690) and (2319.8000,231.8670) ..
    (2331.4600,231.8670) .. controls (2343.1000,231.8670) and (2347.4800,219.4690)
    .. (2347.4800,200.8710) .. controls (2347.4800,182.2730) and
    (2343.1000,169.8750) .. (2331.4600,169.8750) .. controls (2319.8000,169.8750)
    and (2315.4200,182.2730) .. (2315.4200,200.8710) -- (2315.4200,200.8710);

    \path[fill,nonzero rule] (2386.4600,163.9920) -- (2428.0500,163.9920) --
    (2428.0500,172.8670) -- (2400.4700,172.8670) -- (2400.4700,237.7460) --
    (2386.4600,237.7460) -- (2386.4600,163.9920);

    \path[fill,nonzero rule] (2475.2300,162.8240) .. controls
    (2496.8300,162.8240) and (2506.0200,178.3160) .. (2506.0200,200.8710) ..
    controls (2506.0200,223.4260) and (2496.8300,238.9220) .. (2475.2300,238.9220)
    .. controls (2453.5400,238.9220) and (2444.4500,223.4260) ..
    (2444.4500,200.8710) .. controls (2444.4500,178.3160) and (2453.5400,162.8240)
    .. (2475.2300,162.8240) -- (2475.2300,162.8240) -- cycle(2459.2000,200.8710)
    .. controls (2459.2000,219.4690) and (2463.5900,231.8670) ..
    (2475.2300,231.8670) .. controls (2486.8900,231.8670) and (2491.2700,219.4690)
    .. (2491.2700,200.8710) .. controls (2491.2700,182.2730) and
    (2486.8900,169.8750) .. (2475.2300,169.8750) .. controls (2463.5900,169.8750)
    and (2459.2000,182.2730) .. (2459.2000,200.8710) -- (2459.2000,200.8710);

    \path[fill,nonzero rule] (2583.9100,207.3910) -- (2556.6500,207.3910) --
    (2556.6500,198.5160) -- (2569.9100,198.5160) -- (2569.9100,172.8670) ..
    controls (2568.7300,171.3750) and (2565.4200,169.8750) .. (2561.2500,169.8750)
    .. controls (2545.3200,169.8750) and (2542.0100,184.9410) ..
    (2542.0100,202.6880) .. controls (2542.0100,212.5160) and (2542.0100,231.8670)
    .. (2556.9700,231.8670) .. controls (2567.2400,231.8670) and
    (2567.7700,222.7850) .. (2568.0900,218.4060) -- (2583.2700,218.4060) ..
    controls (2583.2700,232.5120) and (2573.0000,238.9220) .. (2556.9700,238.9220)
    .. controls (2534.2000,238.9220) and (2527.2500,223.2110) ..
    (2527.2500,201.5160) .. controls (2527.2500,179.9180) and (2536.8800,162.8240)
    .. (2560.0700,162.8240) .. controls (2570.2300,162.8240) and
    (2578.3500,166.3440) .. (2583.9100,169.6600) -- (2583.9100,207.3910);

    \path[fill,nonzero rule] (2622.3400,163.9920) -- (2636.3400,163.9920) --
    (2636.3400,198.5160) -- (2660.5000,237.7460) -- (2647.0400,237.7460) --
    (2631.0000,210.7030) -- (2615.5000,237.7460) -- (2599.3600,237.7460) --
    (2622.3400,198.5160) -- (2622.3400,163.9920);

    \path[fill,nonzero rule] (183.6880,303.7890) .. controls
    (145.1450,298.2190) and (113.2770,272.0510) .. (99.6328,236.8320) --
    (298.5740,236.8320) .. controls (285.0310,271.7770) and (253.5550,297.8050) ..
    (215.4260,303.6600) -- (215.3980,396.8480) -- (237.7150,393.7810) --
    (241.8480,348.9260) .. controls (250.9920,346.3400) and (259.8010,342.9450) ..
    (268.1800,338.8240) -- (301.3130,369.4060) -- (319.5700,357.1090) --
    (303.5780,314.9410) .. controls (311.9340,307.4610) and (319.4800,299.1020) ..
    (326.0740,290.0000) -- (369.7300,301.4730) -- (380.0660,282.0590) --
    (346.1560,252.3550) .. controls (349.9800,241.9610) and (352.7340,231.0470) ..
    (354.2730,219.7580) -- (398.2030,209.4140) -- (398.2030,187.4300) --
    (354.2730,177.0860) .. controls (352.7340,165.7930) and (349.9800,154.8790) ..
    (346.1560,144.4880) -- (380.0660,114.7930) -- (369.7300,95.3672) --
    (326.0740,106.8360) .. controls (319.4800,97.7344) and (311.9340,89.3828) ..
    (303.5780,81.9023) -- (319.5700,39.7266) -- (301.3130,27.4375) --
    (268.1800,58.0156) .. controls (259.8010,53.8945) and (250.9920,50.5000) ..
    (241.8480,47.9180) -- (237.7150,3.0586) -- (215.3980,0.0000) --
    (215.4380,93.1914) .. controls (254.4800,99.1797) and (286.5430,126.3280) ..
    (299.5200,162.5390) -- (98.6875,162.5390) .. controls (111.7620,126.0470) and
    (144.2190,98.7656) .. (183.6720,93.0547) -- (183.8280,0.0000) --
    (160.4880,3.0586) -- (156.3550,47.9180) .. controls (147.2070,50.5039) and
    (138.4020,53.8945) .. (130.0230,58.0195) -- (96.8906,27.4375) --
    (78.6328,39.7266) -- (94.6250,81.9023) .. controls (86.2695,89.3828) and
    (78.7227,97.7344) .. (72.1289,106.8360) -- (28.4727,95.3672) --
    (18.1367,114.7930) -- (52.0430,144.4880) .. controls (48.2188,154.8910) and
    (45.4688,165.7930) .. (43.9258,177.0860) -- (0.0000,187.4300) --
    (0.0000,209.4140) -- (43.9258,219.7580) .. controls (45.4688,231.0470) and
    (48.2188,241.9530) .. (52.0430,252.3550) -- (18.1367,282.0590) --
    (28.4727,301.4730) -- (72.1289,290.0000) .. controls (78.7227,299.1020) and
    (86.2695,307.4610) .. (94.6250,314.9410) -- (78.6328,357.1090) --
    (96.8906,369.4060) -- (130.0230,338.8240) .. controls (138.4020,342.9450) and
    (147.2070,346.3400) .. (156.3550,348.9260) -- (160.4880,393.7810) --
    (183.8280,396.8480) -- (183.6880,303.7890) -- (183.6880,303.7890);

    \path[fill,nonzero rule] (506.5350,314.7580) -- (520.5270,314.7580) --
    (520.5270,380.0000) -- (538.2540,380.0000) -- (538.2540,388.4340) --
    (488.8090,388.4340) -- (488.8090,380.0000) -- (506.5350,380.0000) --
    (506.5350,314.7580);

    \path[fill,nonzero rule] (552.2460,314.7580) -- (564.6330,314.7580) --
    (571.2620,335.6910) -- (596.3550,335.6910) -- (602.7580,314.7580) --
    (617.6050,314.7580) -- (591.9730,388.4340) -- (577.6600,388.4340) --
    (552.2460,314.7580) -- (552.2460,314.7580) -- cycle(583.8550,376.0470) --
    (584.0660,376.0470) -- (594.0040,343.4840) -- (573.7110,343.4840) --
    (583.8550,376.0470) -- (583.8550,376.0470);

    \path[fill,nonzero rule] (641.5270,314.7580) -- (651.8870,314.7580) --
    (651.8870,376.3670) -- (652.1020,376.3670) -- (673.7810,314.7580) --
    (684.4570,314.7580) -- (706.1330,377.8670) -- (706.3480,377.8670) --
    (706.3480,314.7580) -- (718.7340,314.7580) -- (718.7340,388.4340) --
    (701.0120,388.4340) -- (680.2890,328.3200) -- (680.0820,328.3200) --
    (658.8280,388.4340) -- (641.5270,388.4340) -- (641.5270,314.7580);

    \path[fill,nonzero rule] (750.5660,314.7580) -- (764.5630,314.7580) --
    (764.5630,346.7930) -- (768.0820,346.7930) .. controls (779.7230,346.7930) and
    (797.3440,348.5040) .. (797.3440,368.0430) .. controls (797.3440,385.0200) and
    (785.1720,388.4340) .. (768.0820,388.4340) -- (750.5660,388.4340) --
    (750.5660,314.7580) -- cycle(764.5630,380.6410) -- (768.0820,380.6410) ..
    controls (778.0120,380.6410) and (783.3550,378.3980) .. (783.3550,368.1450) ..
    controls (783.3550,356.2970) and (776.0900,354.5860) .. (768.0820,354.5860) --
    (764.5630,354.5860) -- (764.5630,380.6410);

    \path[fill,nonzero rule] (821.8950,314.7580) -- (865.8910,314.7580) --
    (865.8910,323.6210) -- (835.8830,323.6210) -- (835.8830,348.9260) --
    (863.4340,348.9260) -- (863.4340,357.3630) -- (835.8830,357.3630) --
    (835.8830,380.0000) -- (864.9340,380.0000) -- (864.9340,388.4340) --
    (821.8950,388.4340) -- (821.8950,314.7580);

    \path[fill,nonzero rule] (893.4340,314.7580) -- (907.4220,314.7580) --
    (907.4220,347.0080) -- (911.8010,347.0080) .. controls (922.7970,347.0080) and
    (924.8280,342.0980) .. (927.5000,328.6410) -- (930.1680,314.7580) --
    (944.1600,314.7580) -- (939.9960,334.2970) .. controls (938.1800,342.8440) and
    (936.6880,349.8910) .. (925.7930,351.9140) -- (925.7930,352.1290) .. controls
    (932.4140,353.8400) and (941.1680,357.7890) .. (941.1680,369.2150) .. controls
    (941.1680,385.9840) and (926.5350,388.4340) .. (910.1950,388.4340) --
    (893.4340,388.4340) -- (893.4340,314.7580) -- cycle(907.4220,380.6410) --
    (910.1950,380.6410) .. controls (918.8480,380.6410) and (927.1800,379.8950) ..
    (927.1800,368.1450) .. controls (927.1800,357.3630) and (920.1330,354.8010) ..
    (910.1950,354.8010) -- (907.4220,354.8010) -- (907.4220,380.6410);

    \path[fill,nonzero rule] (970.7580,314.7580) -- (1014.7500,314.7580) --
    (1014.7500,323.6210) -- (984.7460,323.6210) -- (984.7460,348.9260) --
    (1012.3000,348.9260) -- (1012.3000,357.3630) -- (984.7460,357.3630) --
    (984.7460,380.0000) -- (1013.7900,380.0000) -- (1013.7900,388.4340) --
    (970.7580,388.4340) -- (970.7580,314.7580);

    \path[fill,nonzero rule] (1042.1900,314.7580) -- (1086.1900,314.7580) --
    (1086.1900,323.6210) -- (1056.1800,323.6210) -- (1056.1800,348.9260) --
    (1083.7300,348.9260) -- (1083.7300,357.3630) -- (1056.1800,357.3630) --
    (1056.1800,380.0000) -- (1085.2300,380.0000) -- (1085.2300,388.4340) --
    (1042.1900,388.4340) -- (1042.1900,314.7580);

    \path[fill,nonzero rule] (1113.7300,314.7580) -- (1125.1600,314.7580) --
    (1125.1600,372.1020) -- (1125.3700,372.1020) -- (1155.2700,314.7580) --
    (1169.1500,314.7580) -- (1169.1500,388.4340) -- (1157.7300,388.4340) --
    (1157.7300,333.7660) -- (1157.5200,333.7660) -- (1129.0000,388.4340) --
    (1113.7300,388.4340) -- (1113.7300,314.7580);

    \path[fill,nonzero rule] (1258.5800,314.7580) -- (1272.5600,314.7580) --
    (1272.5600,380.0000) -- (1290.2900,380.0000) -- (1290.2900,388.4340) --
    (1240.8500,388.4340) -- (1240.8500,380.0000) -- (1258.5800,380.0000) --
    (1258.5800,314.7580);

    \path[fill,nonzero rule] (1314.1100,314.7580) -- (1358.1100,314.7580) --
    (1358.1100,323.6210) -- (1328.1100,323.6210) -- (1328.1100,348.9260) --
    (1355.6600,348.9260) -- (1355.6600,357.3630) -- (1328.1100,357.3630) --
    (1328.1100,380.0000) -- (1357.1500,380.0000) -- (1357.1500,388.4340) --
    (1314.1100,388.4340) -- (1314.1100,314.7580);

    \path[fill,nonzero rule] (1385.6600,314.7580) -- (1399.6400,314.7580) --
    (1399.6400,350.4220) -- (1399.8600,350.4220) -- (1423.9900,314.7580) --
    (1441.0700,314.7580) -- (1411.9300,355.2270) -- (1438.3000,388.4340) --
    (1423.5700,388.4340) -- (1399.8600,356.4020) -- (1399.6400,356.4020) --
    (1399.6400,388.4340) -- (1385.6600,388.4340) -- (1385.6600,314.7580);

    \path[fill,nonzero rule] (1465.0000,314.7580) -- (1476.4300,314.7580) --
    (1476.4300,372.1020) -- (1476.6400,372.1020) -- (1506.5400,314.7580) --
    (1520.4300,314.7580) -- (1520.4300,388.4340) -- (1509.0000,388.4340) --
    (1509.0000,333.7660) -- (1508.7800,333.7660) -- (1480.2700,388.4340) --
    (1465.0000,388.4340) -- (1465.0000,314.7580);

    \path[fill,nonzero rule] (1552.1600,314.7580) -- (1566.1500,314.7580) --
    (1566.1500,388.4340) -- (1552.1600,388.4340) -- (1552.1600,314.7580);

    \path[fill,nonzero rule] (1597.9700,314.7580) -- (1639.5100,314.7580) --
    (1639.5100,323.6210) -- (1611.9600,323.6210) -- (1611.9600,388.4340) --
    (1597.9700,388.4340) -- (1597.9700,314.7580);

    \path[fill,nonzero rule] (1663.4400,314.7580) -- (1704.9800,314.7580) --
    (1704.9800,323.6210) -- (1677.4200,323.6210) -- (1677.4200,388.4340) --
    (1663.4400,388.4340) -- (1663.4400,314.7580);

    \path[fill,nonzero rule] (1728.8000,314.7580) -- (1742.7900,314.7580) --
    (1742.7900,388.4340) -- (1728.8000,388.4340) -- (1728.8000,314.7580);

    \path[fill,nonzero rule] (1774.6100,314.7580) -- (1786.0300,314.7580) --
    (1786.0300,372.1020) -- (1786.2500,372.1020) -- (1816.1500,314.7580) --
    (1830.0300,314.7580) -- (1830.0300,388.4340) -- (1818.6100,388.4340) --
    (1818.6100,333.7660) -- (1818.3900,333.7660) -- (1789.8800,388.4340) --
    (1774.6100,388.4340) -- (1774.6100,314.7580);

    \path[fill,nonzero rule] (1861.7700,314.7580) -- (1905.7700,314.7580) --
    (1905.7700,323.6210) -- (1875.7600,323.6210) -- (1875.7600,348.9260) --
    (1903.3100,348.9260) -- (1903.3100,357.3630) -- (1875.7600,357.3630) --
    (1875.7600,380.0000) -- (1904.8100,380.0000) -- (1904.8100,388.4340) --
    (1861.7700,388.4340) -- (1861.7700,314.7580);

    \path[fill,nonzero rule] (1933.3100,314.7580) -- (1944.7400,314.7580) --
    (1944.7400,372.1020) -- (1944.9500,372.1020) -- (1974.8600,314.7580) --
    (1988.7300,314.7580) -- (1988.7300,388.4340) -- (1977.3100,388.4340) --
    (1977.3100,333.7660) -- (1977.0900,333.7660) -- (1948.5900,388.4340) --
    (1933.3100,388.4340) -- (1933.3100,314.7580);

    \path[fill,nonzero rule] (2081.5800,314.7580) -- (2095.5700,314.7580) --
    (2095.5700,349.2500) -- (2119.7000,388.4340) -- (2106.2500,388.4340) --
    (2090.2300,361.4220) -- (2074.7400,388.4340) -- (2058.6200,388.4340) --
    (2081.5800,349.2500) -- (2081.5800,314.7580);

    \path[fill,nonzero rule] (2141.8000,314.7580) -- (2183.3500,314.7580) --
    (2183.3500,323.6210) -- (2155.8000,323.6210) -- (2155.8000,388.4340) --
    (2141.8000,388.4340) -- (2141.8000,314.7580);

    \path[fill,nonzero rule] (2207.1600,314.7580) -- (2221.1500,314.7580) --
    (2221.1500,388.4340) -- (2207.1600,388.4340) -- (2207.1600,314.7580);

    \path[fill,nonzero rule] (2280.7400,313.5860) .. controls
    (2302.3100,313.5860) and (2311.4900,329.0630) .. (2311.4900,351.5980) ..
    controls (2311.4900,374.1290) and (2302.3100,389.6090) .. (2280.7400,389.6090)
    .. controls (2259.0600,389.6090) and (2249.9800,374.1290) ..
    (2249.9800,351.5980) .. controls (2249.9800,329.0630) and (2259.0600,313.5860)
    .. (2280.7400,313.5860) -- (2280.7400,313.5860) -- cycle(2264.7200,351.5980)
    .. controls (2264.7200,370.1720) and (2269.1000,382.5660) ..
    (2280.7400,382.5660) .. controls (2292.3800,382.5660) and (2296.7600,370.1720)
    .. (2296.7600,351.5980) .. controls (2296.7600,333.0200) and
    (2292.3800,320.6330) .. (2280.7400,320.6330) .. controls (2269.1000,320.6330)
    and (2264.7200,333.0200) .. (2264.7200,351.5980) -- (2264.7200,351.5980);

    \path[fill,nonzero rule] (2340.2500,314.7580) -- (2354.2300,314.7580) --
    (2354.2300,346.7930) -- (2357.7600,346.7930) .. controls (2369.4000,346.7930)
    and (2387.0200,348.5040) .. (2387.0200,368.0430) .. controls
    (2387.0200,385.0200) and (2374.8400,388.4340) .. (2357.7600,388.4340) --
    (2340.2500,388.4340) -- (2340.2500,314.7580) -- cycle(2354.2300,380.6410) --
    (2357.7600,380.6410) .. controls (2367.6900,380.6410) and (2373.0300,378.3980)
    .. (2373.0300,368.1450) .. controls (2373.0300,356.2970) and
    (2365.7700,354.5860) .. (2357.7600,354.5860) -- (2354.2300,354.5860) --
    (2354.2300,380.6410);

    \path[fill,nonzero rule] (2411.5700,314.7580) -- (2425.5600,314.7580) --
    (2425.5600,388.4340) -- (2411.5700,388.4340) -- (2411.5700,314.7580);

    \path[fill,nonzero rule] (2496.4600,387.5780) .. controls
    (2493.6900,388.1170) and (2485.8900,389.6090) .. (2478.0900,389.6090) ..
    controls (2462.1800,389.6090) and (2453.2100,382.4570) .. (2453.2100,370.6050)
    .. controls (2453.2100,347.3240) and (2488.1300,347.6480) ..
    (2488.1300,330.9880) .. controls (2488.1300,324.0510) and (2481.3000,322.0230)
    .. (2476.6000,322.0230) .. controls (2468.2700,322.0230) and
    (2460.0400,326.3980) .. (2454.3900,329.9220) -- (2454.3900,316.8950) ..
    controls (2457.0500,316.1480) and (2465.4900,313.5860) .. (2474.3600,313.5860)
    .. controls (2490.1600,313.5860) and (2502.1200,319.4610) ..
    (2502.1200,335.4770) .. controls (2502.1200,358.3200) and (2466.1300,359.1760)
    .. (2466.1300,373.5940) .. controls (2466.1300,378.1840) and
    (2470.3000,381.1720) .. (2476.1700,381.1720) .. controls (2484.7200,381.1720)
    and (2493.9000,377.4380) .. (2496.4600,376.1520) -- (2496.4600,387.5780);

    \path[fill,nonzero rule] (2538.6300,314.7580) -- (2552.6300,314.7580) --
    (2552.6300,380.0000) -- (2570.3500,380.0000) -- (2570.3500,388.4340) --
    (2520.9100,388.4340) -- (2520.9100,380.0000) -- (2538.6300,380.0000) --
    (2538.6300,314.7580);

    \path[fill,nonzero rule] (2620.0100,313.5860) .. controls
    (2641.5800,313.5860) and (2650.7700,329.0630) .. (2650.7700,351.5980) ..
    controls (2650.7700,374.1290) and (2641.5800,389.6090) .. (2620.0100,389.6090)
    .. controls (2598.3400,389.6090) and (2589.2600,374.1290) ..
    (2589.2600,351.5980) .. controls (2589.2600,329.0630) and (2598.3400,313.5860)
    .. (2620.0100,313.5860) -- (2620.0100,313.5860) -- cycle(2604.0000,351.5980)
    .. controls (2604.0000,370.1720) and (2608.3800,382.5660) ..
    (2620.0100,382.5660) .. controls (2631.6500,382.5660) and (2636.0400,370.1720)
    .. (2636.0400,351.5980) .. controls (2636.0400,333.0200) and
    (2631.6500,320.6330) .. (2620.0100,320.6330) .. controls (2608.3800,320.6330)
    and (2604.0000,333.0200) .. (2604.0000,351.5980) -- (2604.0000,351.5980);
\end{scope}
\end{tikzpicture}
}
\endinput
