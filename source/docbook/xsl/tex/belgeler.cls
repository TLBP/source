%%
%% Copyright ©  2007  Nilgün Belma Bugüner <nilgun@belgeler.gen.tr>
%%
%% This program is free software; you can redistribute it and/or modify
%% it under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2 of the License, or
%% (at your option) any later version.
%%
%% This program is distributed in the hope that it will be useful,
%% but WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%% GNU General Public License for more details.
%%
%% You should have received a copy of the GNU General Public License
%% along with this program; if not, write to the Free Software
%% Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA.
%%
\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{belgeler}[2007/01/11 v1.0 belgeler.org-specific LaTeX document class]

\RequirePackage[utf8]{inputenc}
\RequirePackage[english,turkish]{babel}
\RequirePackage{courier,times,color,graphicx,xcolor}
\RequirePackage[scaled=.92]{helvet}
\RequirePackage[LY1]{fontenc}

\newcommand\@ptsize{}
\newif\if@restonecol
\newif\if@titlepage
\@titlepagefalse
\if@compatibility\else
\DeclareOption{a4paper}
   {\setlength\paperheight {297mm}%
    \setlength\paperwidth  {210mm}}
\DeclareOption{a5paper}
   {\setlength\paperheight {210mm}%
    \setlength\paperwidth  {148mm}}
\DeclareOption{b5paper}
   {\setlength\paperheight {250mm}%
    \setlength\paperwidth  {176mm}}
\DeclareOption{letterpaper}
   {\setlength\paperheight {11in}%
    \setlength\paperwidth  {8.5in}}
\DeclareOption{legalpaper}
   {\setlength\paperheight {14in}%
    \setlength\paperwidth  {8.5in}}
\DeclareOption{executivepaper}
   {\setlength\paperheight {10.5in}%
    \setlength\paperwidth  {7.25in}}
\DeclareOption{landscape}
   {\setlength\@tempdima   {\paperheight}%
    \setlength\paperheight {\paperwidth}%
    \setlength\paperwidth  {\@tempdima}}
\fi
\if@compatibility
  \renewcommand\@ptsize{0}
\else
\DeclareOption{10pt}{\renewcommand\@ptsize{0}}
\fi
\DeclareOption{11pt}{\renewcommand\@ptsize{1}}
\DeclareOption{12pt}{\renewcommand\@ptsize{2}}
\if@compatibility\else
\DeclareOption{oneside}{\@twosidefalse \@mparswitchfalse}
\fi
\DeclareOption{twoside}{\@twosidetrue  \@mparswitchtrue}
\DeclareOption{draft}{\setlength\overfullrule{5pt}}
\if@compatibility\else
\DeclareOption{final}{\setlength\overfullrule{0pt}}
\fi
\DeclareOption{titlepage}{\@titlepagetrue}
\if@compatibility\else
\DeclareOption{notitlepage}{\@titlepagefalse}
\fi
\if@compatibility\else
\DeclareOption{onecolumn}{\@twocolumnfalse}
\fi
\DeclareOption{twocolumn}{\@twocolumntrue}
\DeclareOption{leqno}{\input{leqno.clo}}
\DeclareOption{fleqn}{\input{fleqn.clo}}
\DeclareOption{openbib}{%
  \AtEndOfPackage{%
   \renewcommand\@openbib@code{%
      \advance\leftmargin\bibindent
      \itemindent -\bibindent
      \listparindent \itemindent
      \parsep \z@
      }%
   \renewcommand\newblock{\par}}%
}
\ExecuteOptions{a4paper,11pt,onecolumn,final}
\ProcessOptions
\input{size1\@ptsize.clo}
\setlength\lineskip{1\p@}
\setlength\normallineskip{1\p@}
\renewcommand\baselinestretch{}
\setlength{\parindent}{0pt}
\setlength\parskip{1.2ex plus0.5ex minus0.2ex}
\@lowpenalty   51
\@medpenalty  151
\@highpenalty 301
\setcounter{topnumber}{2}
\renewcommand\topfraction{.7}
\setcounter{bottomnumber}{1}
\renewcommand\bottomfraction{.3}
\setcounter{totalnumber}{3}
\renewcommand\textfraction{.2}
\renewcommand\floatpagefraction{.5}
\setcounter{dbltopnumber}{2}
\renewcommand\dbltopfraction{.7}
\renewcommand\dblfloatpagefraction{.5}

\if@titlepage
  \newcommand\maketitle{\begin{titlepage}%
  \let\footnotesize\small
  \let\footnoterule\relax
  \let \footnote \thanks
  \null\vfil
  \vskip 60\p@
  \begin{center}%
    {\@title \par}%
    \vskip 3em%
    {\large
     \lineskip .75em%
      \begin{tabular}[t]{c}%
        \@author
      \end{tabular}\par}%
      \vskip 1.5em%
    {\large \@date \par}%       % Set date in \large size.
  \end{center}\par
  \@thanks
  \vfil\null
  \end{titlepage}%
  \setcounter{backnote}{0}
  \setcounter{footnote}{0}%
  \global\let\thanks\relax
  \global\let\maketitle\relax
  \global\let\@thanks\@empty
  \global\let\@author\@empty
  \global\let\@date\@empty
  \global\let\@title\@empty
  \global\let\title\relax
  \global\let\author\relax
  \global\let\date\relax
  \global\let\and\relax
}
\else
\newcommand\maketitle{\par
  \begingroup
    \renewcommand\thefootnote{\@fnsymbol\c@footnote}%
    \def\@makefnmark{\rlap{\@textsuperscript{\normalfont\@thefnmark}}}%
    \long\def\@makefntext##1{\parindent 1em\noindent
            \hb@xt@1.8em{%
                \hss\@textsuperscript{\normalfont\@thefnmark}}##1}%
    \if@twocolumn
      \ifnum \col@number=\@ne
        \@maketitle
      \else
        \twocolumn[\@maketitle]%
      \fi
    \else
      \newpage
      \global\@topnum\z@   % Prevents figures from going at top of page.
      \@maketitle
    \fi
    \thispagestyle{plain}\@thanks
  \endgroup
  \setcounter{backnote}{0}%
  \setcounter{footnote}{0}%
  \global\let\thanks\relax
  \global\let\maketitle\relax
  \global\let\@maketitle\relax
  \global\let\@thanks\@empty
  \global\let\@author\@empty
  \global\let\@date\@empty
  \global\let\@title\@empty
  \global\let\title\relax
  \global\let\author\relax
  \global\let\date\relax
  \global\let\and\relax
}
\def\@maketitle{%
  \newpage
  \null
  \vskip 2em%
  \begin{center}%
  \let \footnote \thanks
    {\@title \par}%
    \vskip 1.5em%
    {%\large
      \lineskip .5em%
      \begin{tabular}[t]{c}%
        \@author
      \end{tabular}\par}%
    \vskip 1em%
    {\large \@date}%
  \end{center}%
  \par
  \vskip 1.5em}
\fi

\if@twocolumn
  \setlength\leftmargini  {2em}
\else
  \setlength\leftmargini  {2.5em}
\fi
\leftmargin  \leftmargini
\setlength\leftmarginii  {2.2em}
\setlength\leftmarginiii {1.87em}
\setlength\leftmarginiv  {1.7em}
\if@twocolumn
  \setlength\leftmarginv  {.5em}
  \setlength\leftmarginvi {.5em}
\else
  \setlength\leftmarginv  {1em}
  \setlength\leftmarginvi {1em}
\fi
\setlength  \labelsep  {.5em}
\setlength  \labelwidth{\leftmargini}
\addtolength\labelwidth{-\labelsep}
\@beginparpenalty -\@lowpenalty
\@endparpenalty   -\@lowpenalty
\@itempenalty     -\@lowpenalty
\newenvironment{description}
               {\list{}{\labelwidth\z@ \itemindent-\leftmargin
                        \let\makelabel\descriptionlabel}}
               {\endlist}
\newcommand*\descriptionlabel[1]{\leftline{\hspace\labelsep
                                \normalfont #1}}
\if@titlepage
  \newenvironment{abstract}{%
      \titlepage
      \null\vfil
      \@beginparpenalty\@lowpenalty
      \begin{center}%
        \bfseries \abstractname
        \@endparpenalty\@M
      \end{center}}%
     {\par\vfil\null\endtitlepage}
\else
  \newenvironment{abstract}{%
      \if@twocolumn
        \sectone[\abstractname]%
      \else
        \begin{center}%
          {\bfseries \abstractname\vspace{-.5em}\vspace{\z@}}%
        \end{center}%
        \quotation%
      \fi}
      {\if@twocolumn\else\endquotation\fi}
\fi
%
\newenvironment{quotation}
  {\vspace{-2ex}%
  \list{}{\listparindent 0em%
    \itemindent    \listparindent
    \rightmargin   \leftmargin
    \parsep     1.2ex plus 0.5ex minus 0.5ex}%
  \item\relax}
  {\endlist}
%
\if@compatibility
  \newenvironment{titlepage}
  {%
    \if@twocolumn
      \@restonecoltrue\onecolumn
    \else
      \@restonecolfalse\newpage
    \fi
    \thispagestyle{empty}%
    \setcounter{page}\z@
  }%
  {\if@restonecol\twocolumn \else \newpage \fi
  }
\else
  \newenvironment{titlepage}
  {%
    \if@twocolumn
      \@restonecoltrue\onecolumn
    \else
      \@restonecolfalse\newpage
    \fi
    \thispagestyle{empty}%
    \setcounter{page}\@ne
  }%
  {\if@restonecol\twocolumn \else \newpage \fi
    \if@twoside\else
      \setcounter{page}\@ne
    \fi
  }
\fi
%
\setlength\arraycolsep{5\p@}
\setlength\tabcolsep{0.3ex}
\setlength\arrayrulewidth{.4\p@}
\setlength\doublerulesep{2\p@}
\setlength\tabbingsep{\labelsep}
\setlength\headheight{13.6pt}
\skip\@mpfootins = \skip\footins
\skip\footins=18pt plus 4pt minus 0pt % space added when footnote is present
\dimen\footins=8in % maximum footnotes per page
\setlength\fboxsep{3\p@}
\setlength\fboxrule{.4\p@}
\DeclareOldFontCommand{\rm}{\normalfont\rmfamily}{\mathrm}
\DeclareOldFontCommand{\sf}{\normalfont\sffamily}{\mathsf}
\DeclareOldFontCommand{\tt}{\normalfont\ttfamily}{\mathtt}
\DeclareOldFontCommand{\bf}{\normalfont\bfseries}{\mathbf}
\DeclareOldFontCommand{\it}{\normalfont\itshape}{\mathit}
\DeclareOldFontCommand{\sl}{\normalfont\slshape}{\@nomath\sl}
\DeclareOldFontCommand{\sc}{\normalfont\scshape}{\@nomath\sc}
\DeclareRobustCommand*\cal{\@fontswitch\relax\mathcal}
\DeclareRobustCommand*\mit{\@fontswitch\relax\mathnormal}
\newcommand\@tocrmarg{2.55em}
\newcommand\@dotsep{4.5}

\def\dottedtocline#1#2#3{%
  \setbox0=\hbox{#3}
  \vskip \z@ \@plus.2\p@
    {\leftskip #1\relax \rightskip \@tocrmarg \parfillskip -\rightskip
     \parindent #1\relax\@afterindenttrue
     \interlinepenalty\@M
     \leavevmode
     {#2}\nobreak
     \leaders\hbox{$\m@th
        \mkern \@dotsep mu\hbox{.}\mkern \@dotsep
        mu$}\hfill
     \nobreak
     \box0\par\addvspace{-6pt}}}

\newcommand\newblock{\hskip .11em\@plus.33em\@minus.07em}
\newcommand\@idxitem{\par\hangindent 40\p@}
\renewcommand\footnoterule{%
  \kern 3\p@
  \hrule\@width .4\columnwidth
  \kern 2.6\p@}
\@addtoreset{footnote}{part}
\newcommand\@makefntext[1]{%
    \parindent 1em%
    \noindent
    \hb@xt@1.8em{\hss\@makefnmark}#1}
\newcommand\examplename{\"Ornek}
\newcounter{example}
\renewcommand\theexample{\@arabic\c@example .}
\newcommand\example{\refstepcounter{example}\par
  \addvspace{12pt minus 4pt}%
  {\bfseries\textcolor{hlcolor}{\examplename\ \theexample}}\hspace{1ex}}

\newcounter{scnline}
\renewcommand\thescnline{\@arabic\c@scnline}
\def\scnline#1#2{\refstepcounter{scnline}%
  \boxwdt=\scrwdt \advance\boxwdt by-1.8pt%
  \setbox0=\hbox to\boxwdt{\hskip1pt\scalebox{.71}{\lower-.25ex\hbox{\thescnline}}%
  \hskip3pt\tt #2\sf\hss\strut}\boxhgt\ht0\advance\boxhgt by\addhgt%
  \leftline{\hspace{\indentwdt}\textcolor{BorderColor}{\vrule height\boxhgt}%
  \hskip0.5pt\fboxsep0pt\colorbox{#1}{\normalcolor\box0}\hskip0.5pt%
  \textcolor{BorderColor}{\vrule height\boxhgt}\vspace{-0.8pt}}}

\newcommand\figurename{\,Sekil}
\newcounter{figure}
\renewcommand \thefigure{\@arabic\c@figure .}
\newcommand\figure{\refstepcounter{figure}\par
  \addvspace{12pt minus 4pt}%
  {\hspace{\indentwdt}\bfseries\textcolor{hlcolor}{\figurename\ \thefigure}}\hspace{1ex}}

\newcommand\procedurename{Y\"onerge}
\newcounter{procedure}
\renewcommand \theprocedure{\@arabic\c@procedure .}
\newcommand\procedure{\refstepcounter{procedure}\par
  \addvspace{12pt minus 4pt}%
  {\hspace{\indentwdt}\bfseries\textcolor{hlcolor}{\procedurename\ \theprocedure}}\hspace{1ex}}

\def\today{\ifcase\month\or
  January\or February\or March\or April\or May\or June\or
  July\or August\or September\or October\or November\or December\fi
  \space\number\day, \number\year}
\setlength\columnsep{26\p@}
\setlength\columnseprule{0\p@}
\pagestyle{plain}
\pagenumbering{arabic}
\if@twoside
\else
  \raggedbottom
\fi
\if@twocolumn
  \twocolumn
  \sloppy
  \flushbottom
\else
  \onecolumn
  \sloppy
\fi
%
\definecolor{titlecolor}{rgb}{0,0,0}
\definecolor{hlcolor}{rgb}{0,0,0}
\definecolor{linkcolor}{rgb}{0,0.2,0.5}
%\definecolor{rplcolor}{rgb}{0,0,0}
\definecolor{warncolor}{rgb}{0,0,0}
%\definecolor{titlecolor}{cmyk}{0,0.81,1,0.60}
\definecolor{ttcolor}{cmyk}{0,0.77,0.78,0.8}
%\definecolor{linkcolor}{rgb}{0,0,0.7}
\definecolor{rplcolor}{rgb}{0,0.4,0}
%\definecolor{warncolor}{rgb}{0,0,0.4}
\def\tuserinput#1{{\tt\userinput{#1}}}
\def\userinput#1{{\bfseries\textcolor{ttcolor}{#1}}}
\def\tmonospace#1{{\tt\monospace{#1}}}
\def\monospace#1{\textcolor{ttcolor}{#1}}
\def\treplaceable#1{{\large\rm\itshape\textcolor{rplcolor}{#1}}}
\def\replaceable#1{{\normalsize\rm\itshape\textcolor{rplcolor}{#1}}}
\def\wordasword#1{{\itshape\bfseries\textcolor{rplcolor}{#1}}}
\def\italics#1{{\itshape{}#1}}
\def\boldface#1{{\bfseries{}#1}}
\def\iboldface#1{{\itshape\bfseries\textcolor{hlcolor}{#1}}}
\def\URL#1{{\tt\textcolor{linkcolor}{\url{#1}}}}
\def\noURL#1{\url{#1}}
\def\innerURL#1{{\itshape\URLtext{#1}}}
\def\URLtext#1{\textcolor{linkcolor}{#1}}
\def\authorname#1{{\bfseries\Large\color{hlcolor}#1}}
\def\authoremail#1{{\small\color{linkcolor}#1}}
\def\othermail#1{{\color{linkcolor}#1}}
\definecolor{ScreenColor}{rgb}{1,1,0.90}
\definecolor{RowColor}{rgb}{1,1,1}
\definecolor{HeadColor}{rgb}{0.98,0.98,0.95}
\definecolor{SynopsColor}{rgb}{0.96,1,0.96}
\definecolor{BorderColor}{rgb}{0.5,0.5,0.5}
%\arrayrulecolor{BorderColor}
\def\screencolor{\rowcolor{ScreenColor}[0.2\tabcolsep]}
\def\headcolor{\rowcolor{HeadColor}[0.2\tabcolsep]}
\def\titleface#1{{\Huge\bfseries\textcolor{titlecolor}{#1}}}
\def\subtitleface#1{{\Large\bfseries\itshape\textcolor{titlecolor}{#1}}}
\def\conum#1{\textcircled{\userinput{\footnotesize #1}}}
\def\lbldisc{\leavevmode\lower.5ex\hbox{\huge\textbullet}}
\def\lblbullet{\lbldisc}
\def\lblcircle{\scalebox{1.2}{\lower.8ex\hbox{\Large\textdegree}}\hskip1.7pt}
\def\lblsquare{\fboxsep0pt\lower-0.4ex \hbox{\fbox{\vrule width.4em height0.4em depth-.4em}}\hskip1.5pt}
\def\lblblacksquare{\vrule width.4em height.7em depth-.3em\hskip1.5pt}
\def\superscript#1{\scalebox{.71}{\hskip.4pt\lower-1ex\hbox{#1}}}
\def\subscript#1{\scalebox{.71}{\hskip.4pt\lower1ex\hbox{#1}}}
\def\duscore{\textunderscore\hskip1.5pt\textunderscore}
\def\backnote#1{\hypertarget{fn#1}{}\label{fn#1}\superscript{(\innerURL{\hyperlink{bn#1}{#1}})}}
\def\backnoteref#1{\superscript{(\innerURL{\hyperlink{bn#1}{#1}})}}
\def\backnotetarget#1{\superscript{(\innerURL{\hyperlink{fn#1}{#1}})}}
\newcounter{backnote}
\def\thebacknote{\@arabic\c@backnote}
\def\otherbacknote#1{\hypertarget{ofn#1}{}\label{ofn#1}\superscript{(\innerURL{\hyperlink{obn#1}{B#1}})}}
\def\otherbacknotetarget#1{\superscript{(\innerURL{\hyperlink{ofn#1}{B#1}})}}

%\pdfstringdefDisableCommands{%
%\let~\textasciitilde
%\def\url{\pdfstringdefwarn\url}%
%\let\textcolor\@gobble}
%
%% girintili paragraf (Groff'taki .IP)
\def\enhanceindent{\global\advance\indentwdt by\addindwdt%
  \global\indentedwdt\linewidth%
  \advance\indentedwdt by-1\indentwdt%
  \global\scrwdt\indentedwdt}
\def\reduceindent{\global\advance\indentwdt by-1\addindwdt%
  \global\indentedwdt\linewidth%
  \advance\indentedwdt by-1\indentwdt%
  \global\scrwdt\indentedwdt}
\def\notetitle#1#2{%\setkeys{Gin}{width=0.55\addindwdt}%
  \thisiw\indentwdt\advance\thisiw by-1\addindwdt%
  \thispw\indentedwdt\advance\thispw by-1\addindwdt%
  \setbox0=\vbox{\strut\vtop{\hsize\addindwdt\centering%
  \scalebox{.607}{\epsfbox{#1}}}%
  \strut\vtop{\hsize\indentedwdt\centerline{{\bfseries #2}}}\strut}%
  \par\addvspace{9pt minus 2pt}\hspace{\thisiw}\box0\par}
\def\normfigbox#1{\setkeys{Gin}{width=0.69\indentedwdt}%
  \setbox0=\vbox{\hsize\indentedwdt\centering\includegraphics{#1}}%
  \par\addvspace{9pt minus 2pt}\hspace{\indentwdt}\box0\par}
\def\optmfigbox#1{\setbox0=\vbox{\hsize\indentedwdt%
  \centering\scalebox{.607}{\epsfbox{#1}}}%
  \par\addvspace{9pt minus 2pt}\hspace{\indentwdt}\box0\par}
%% screen
\def\ltline#1{\leftline{\hspace{\indentwdt}\strut\tt\monospace{#1}\sf\strut}}
\def\scline#1#2{\boxwdt=\scrwdt \advance\boxwdt by-1.8pt%
  \setbox0=\hbox to\boxwdt{\hskip3pt\tt #2\sf\hss\strut}\boxhgt\ht0\advance\boxhgt by\addhgt%
  \leftline{\hspace{\indentwdt}\textcolor{BorderColor}{\vrule height\boxhgt}\hskip0.5pt%
  \fboxsep0pt\colorbox{#1}{\normalcolor\box0}\hskip0.5pt%
  \textcolor{BorderColor}{\vrule height\boxhgt}\vspace{-0.8pt}}}
\def\fscline{\setcounter{scnline}{0} \offinterlineskip\small%
  \boxwdt=\scrwdt \advance\boxwdt by\indentwdt%
  \par\hbox to\boxwdt{\hspace{\indentwdt}\textcolor{BorderColor}{\hrulefill}}}
\def\lscline{\vspace{0.8pt}\boxwdt=\scrwdt \advance\boxwdt by\indentwdt%
  \hbox to\boxwdt{\hspace{\indentwdt}\textcolor{BorderColor}{\hrulefill}}%
  \normalbaselines\normalsize}
\def\funcsynopsis#1{\boxwdt\linewidth\advance\boxwdt by-7.7pt%
  \par\vspace{6pt minus 2pt}\setbox0\vbox{#1}%
  \textcolor{BorderColor}{\fboxsep0.5pt\fbox{%
  \fboxsep3pt\colorbox{SynopsColor}{\wd0\boxwdt \normalcolor\box0}}}%
  \vspace{6pt minus 2pt}}
%% TABLOLAR
% satır çizgileri
\def\ocolline#1{\offinterlineskip\leftline{%
  \hspace{\indentwdt}\textcolor{BorderColor}{\hrulefill}}}
\def\lcolline#1{\vspace{0.8pt}\leftline{%
  \hspace{\indentwdt}\textcolor{BorderColor}{\hrulefill}}%
  \normalbaselines}
% Sütun genişlikleri
\def\cols(#1)(#2){\global\rowwdt\indentedwdt \advance\rowwdt by-1.2pt%
  \ifnextchar({\colsj(#1)(#2)}{
  \global\colwdta=#1\rowwdt \advance\colwdta by-4.2pt%
  \global\colwdtb=#2\rowwdt \advance\colwdtb by-4.2pt}}
\def\colsj(#1)(#2)(#3){\ifnextchar({\colsjj(#1)(#2)(#3)}{%
  \global\colwdta=#1\rowwdt \advance\colwdta by-4.3pt%
  \global\colwdtb=#2\rowwdt \advance\colwdtb by-4.4pt%
  \global\colwdtc=#3\rowwdt \advance\colwdtc by-4.3pt}}
\def\colsjj(#1)(#2)(#3)(#4){\ifnextchar({\colsjjj(#1)(#2)(#3)(#4)}{%
  \global\colwdta=#1\rowwdt \advance\colwdta by-4.3pt%
  \global\colwdtb=#2\rowwdt \advance\colwdtb by-4.4pt%
  \global\colwdtc=#3\rowwdt \advance\colwdtc by-4.3pt%
  \global\colwdtd=#4\rowwdt \advance\colwdtd by-4.4pt}}
\def\colsjjj(#1)(#2)(#3)(#4)(#5){\ifnextchar({\colsjw(#1)(#2)(#3)(#4)(#5)}{%
  \global\colwdta=#1\rowwdt \advance\colwdta by-4.3pt%
  \global\colwdtb=#2\rowwdt \advance\colwdtb by-4.4pt%
  \global\colwdtc=#3\rowwdt \advance\colwdtc by-4.3pt%
  \global\colwdtd=#4\rowwdt \advance\colwdtd by-4.4pt%
  \global\colwdte=#5\rowwdt \advance\colwdte by-4.3pt}}
\def\colsjw(#1)(#2)(#3)(#4)(#5)(#6){\ifnextchar({\colsw(#1)(#2)(#3)(#4)(#5)(#6)}{%
  \global\colwdta=#1\rowwdt \advance\colwdta by-4.3pt%
  \global\colwdtb=#2\rowwdt \advance\colwdtb by-4.4pt%
  \global\colwdtc=#3\rowwdt \advance\colwdtc by-4.3pt%
  \global\colwdtd=#4\rowwdt \advance\colwdtd by-4.4pt%
  \global\colwdte=#5\rowwdt \advance\colwdte by-4.3pt%
  \global\colwdtf=#6\rowwdt \advance\colwdtf by-4.4pt}}
\def\colsw(#1)(#2)(#3)(#4)(#5)(#6)(#7){\ifnextchar({\colswj(#1)(#2)(#3)(#4)(#5)(#6)(#7)}{%
  \global\colwdta=#1\rowwdt \advance\colwdta by-4.3pt%
  \global\colwdtb=#2\rowwdt \advance\colwdtb by-4.4pt%
  \global\colwdtc=#3\rowwdt \advance\colwdtc by-4.3pt%
  \global\colwdtd=#4\rowwdt \advance\colwdtd by-4.4pt%
  \global\colwdte=#5\rowwdt \advance\colwdte by-4.3pt%
  \global\colwdtf=#6\rowwdt \advance\colwdtf by-4.4pt%
  \global\colwdtg=#7\rowwdt \advance\colwdtg by-4.3pt}}
\def\colswj(#1)(#2)(#3)(#4)(#5)(#6)(#7)(#8){%
  \ifnextchar({\colswjj(#1)(#2)(#3)(#4)(#5)(#6)(#7)(#8)}{%
  \global\colwdta=#1\rowwdt \advance\colwdta by-4.3pt%
  \global\colwdtb=#2\rowwdt \advance\colwdtb by-4.4pt%
  \global\colwdtc=#3\rowwdt \advance\colwdtc by-4.3pt%
  \global\colwdtd=#4\rowwdt \advance\colwdtd by-4.4pt%
  \global\colwdte=#5\rowwdt \advance\colwdte by-4.3pt%
  \global\colwdtf=#6\rowwdt \advance\colwdtf by-4.4pt%
  \global\colwdtg=#7\rowwdt \advance\colwdtg by-4.3pt%
  \global\colwdth=#8\rowwdt \advance\colwdth by-4.4pt}}
\def\colswjj(#1)(#2)(#3)(#4)(#5)(#6)(#7)(#8)(#9){%
  \global\colwdta=#1\rowwdt \advance\colwdta by-4.3pt%
  \global\colwdtb=#2\rowwdt \advance\colwdtb by-4.4pt%
  \global\colwdtc=#3\rowwdt \advance\colwdtc by-4.3pt%
  \global\colwdtd=#4\rowwdt \advance\colwdtd by-4.4pt%
  \global\colwdte=#5\rowwdt \advance\colwdte by-4.3pt%
  \global\colwdtf=#6\rowwdt \advance\colwdtf by-4.4pt%
  \global\colwdtg=#7\rowwdt \advance\colwdtg by-4.3pt%
  \global\colwdth=#8\rowwdt \advance\colwdth by-4.4pt%
  \global\colwdti=#9\rowwdt \advance\colwdti by-4.3pt}
% Başlık satırını yazar
\def\head@row#1#2{\leftline{\hspace{\indentwdt}%
  \textcolor{BorderColor}{\vrule height#1 depth4.6pt width0.4pt}%
  \hskip0.5pt\fboxsep0pt\colorbox{HeadColor}{#2}\hskip0.2pt%
  \textcolor{BorderColor}{\vrule height#1 depth4.6pt width0.4pt}\vspace{-0.8pt}}}
% Başlık satırının sütunlarını oluşturur (alta yanaşık)
\def\headcol#1#2{\textcolor{BorderColor}{\vrule}\hskip2pt\vbox{\hsize#2 #1}\hskip2pt}
% Başlık satırlarını oluşturan makrolar
\def\headrow[#1]{\ifnextchar[{\headrowi[#1]}{}}
\def\headrowi[#1][#2]{\ifnextchar[{\headrowii[#1][#2]}{%
    \setbox0=\vbox{\hsize=\rowwdt%
    \hskip2pt\vbox{\hsize=\colwdta #1}\hskip2pt%
    \headcol{#2}{\colwdtb}}%
  \vrulehgt=\ht0 \advance\vrulehgt by\addhgt%
  \head@row{\vrulehgt}{\box0}}}
\def\headrowii[#1][#2][#3]{\ifnextchar[{\headrowiii[#1][#2][#3]}{%
  \setbox0=\vbox{\hsize=\rowwdt%
    \hskip2pt\vbox{\hsize=\colwdta #1}\hskip2pt%
    \headcol{#2}{\colwdtb}\headcol{#3}{\colwdtc}}%
  \vrulehgt=\ht0 \advance\vrulehgt by\addhgt%
  \head@row{\vrulehgt}{\box0}}}
\def\headrowiii[#1][#2][#3][#4]{\ifnextchar[{\headrowiv[#1][#2][#3][#4]}{%
  \setbox0=\vbox{\hsize=\rowwdt%
    \hskip2pt\vbox{\hsize=\colwdta #1}\hskip2pt%
    \headcol{#2}{\colwdtb}\headcol{#3}{\colwdtc}\headcol{#4}{\colwdtd}}%
  \vrulehgt=\ht0 \advance\vrulehgt by\addhgt%
  \head@row{\vrulehgt}{\box0}}}
\def\headrowiv[#1][#2][#3][#4][#5]{%
  \ifnextchar[{\headrowv[#1][#2][#3][#4][#5]}{%
  \setbox0=\vbox{\hsize=\rowwdt%
    \hskip2pt\vbox{\hsize=\colwdta #1}\hskip2pt%
    \headcol{#2}{\colwdtb}\headcol{#3}{\colwdtc}\headcol{#4}{\colwdtd}%
    \headcol{#5}{\colwdte}}%
  \vrulehgt=\ht0 \advance\vrulehgt by\addhgt%
  \head@row{\vrulehgt}{\box0}}}
\def\headrowv[#1][#2][#3][#4][#5][#6]{%
  \ifnextchar[{\headrowvi[#1][#2][#3][#4][#5][#6]}{%
  \setbox0=\vbox{\hsize=\rowwdt%
    \hskip2pt\vbox{\hsize=\colwdta #1}\hskip2pt%
    \headcol{#2}{\colwdtb}\headcol{#3}{\colwdtc}\headcol{#4}{\colwdtd}%
    \headcol{#5}{\colwdte}\headcol{#6}{\colwdtf}}%
  \vrulehgt=\ht0 \advance\vrulehgt by\addhgt%
  \head@row{\vrulehgt}{\box0}}}
\def\headrowvi[#1][#2][#3][#4][#5][#6][#7]{%
  \ifnextchar[{\headrowvii[#1][#2][#3][#4][#5][#6][#7]}{%
  \setbox0=\vbox{\hsize=\rowwdt%
    \hskip2pt\vbox{\hsize=\colwdta #1}\hskip2pt%
    \headcol{#2}{\colwdtb}\headcol{#3}{\colwdtc}\headcol{#4}{\colwdtd}%
    \headcol{#5}{\colwdte}\headcol{#6}{\colwdtf}\headcol{#7}{\colwdtg}}%
  \vrulehgt=\ht0 \advance\vrulehgt by\addhgt%
  \head@row{\vrulehgt}{\box0}}}
\def\headrowvii[#1][#2][#3][#4][#5][#6][#7][#8]{%
  \ifnextchar[{\headrowviii[#1][#2][#3][#4][#5][#6][#7][#8]}{%
  \setbox0=\vbox{\hsize=\rowwdt%
    \hskip2pt\vbox{\hsize=\colwdta #1}\hskip2pt%
    \headcol{#2}{\colwdtb}\headcol{#3}{\colwdtc}\headcol{#4}{\colwdtd}%
    \headcol{#5}{\colwdte}\headcol{#6}{\colwdtf}\headcol{#7}{\colwdtg}%
    \headcol{#8}{\colwdth}}%
  \vrulehgt=\ht0 \advance\vrulehgt by\addhgt%
  \head@row{\vrulehgt}{\box0}}}
\def\headrowviii[#1][#2][#3][#4][#5][#6][#7][#8][#9]{%
  \setbox0=\vbox{\hsize=\rowwdt%
    \hskip2pt\vbox{\hsize=\colwdta #1}\hskip2pt%
    \headcol{#2}{\colwdtb}\headcol{#3}{\colwdtc}\headcol{#4}{\colwdtd}%
    \headcol{#5}{\colwdte}\headcol{#6}{\colwdtf}\headcol{#7}{\colwdtg}%
    \headcol{#8}{\colwdth}\headcol{#9}{\colwdti}}%
  \vrulehgt=\ht0 \advance\vrulehgt by\addhgt%
  \head@row{\vrulehgt}{\box0}}
% Gövde satırını yazar
\def\body@row#1#2{\leftline{\hspace{\indentwdt}%
  \textcolor{BorderColor}{\vrule height10.5pt depth#1 width0.4pt}%
  \hskip0.5pt\fboxsep0pt\colorbox{RowColor}{#2}\hskip0.2pt%
  \textcolor{BorderColor}{\vrule height10.5pt depth#1 width0.4pt}\vspace{-0.8pt}}}
% Gövde satırının sütunlarını oluşturur (üste yanaşık)
\def\bodycol#1#2{\textcolor{BorderColor}{\vrule}\hskip2pt\vtop{\hsize#2 #1}\hskip2pt}
% iç satırların gözeleri
\def\innercell#1#2{\vtop{\hsize#1 #2}}
\def\cellline#1{\hbox to#1{\textcolor{BorderColor}{\hrulefill}}}
% Gövde satırlarını oluşturan makrolar
\def\bodyrow[#1]{\ifnextchar[{\bodyrowi[#1]}{}}
\def\bodyrowi[#1][#2]{\ifnextchar[{\bodyrowii[#1][#2]}{%
  \setbox0=\vbox{\hsize=\rowwdt%
    \hskip2pt\vtop{\hsize=\colwdta \global\scrwdt\colwdta #1}\hskip2pt%
    \global\scrwdt\colwdtb\bodycol{#2}{\colwdtb}}%
  \vrulehgt=\dp0 \advance\vrulehgt by\addhgt%
  \body@row{\vrulehgt}{\box0}}}
\def\bodyrowii[#1][#2][#3]{\ifnextchar[{\bodyrowiii[#1][#2][#3]}{%
  \setbox0=\vbox{\hsize=\rowwdt%
    \hskip2pt\vtop{\hsize=\colwdta \global\scrwdt\colwdta #1}\hskip2pt%
    \global\scrwdt\colwdtb\bodycol{#2}{\colwdtb}%
    \global\scrwdt\colwdtc\bodycol{#3}{\colwdtc}}%
  \vrulehgt=\dp0 \advance\vrulehgt by\addhgt%
  \body@row{\vrulehgt}{\box0}}}
\def\bodyrowiii[#1][#2][#3][#4]{\ifnextchar[{\bodyrowiv[#1][#2][#3][#4]}{%
  \setbox0=\vbox{\hsize=\rowwdt%
    \hskip2pt\vtop{\hsize=\colwdta \global\scrwdt\colwdta #1}\hskip2pt%
    \global\scrwdt\colwdtb\bodycol{#2}{\colwdtb}%
    \global\scrwdt\colwdtc\bodycol{#3}{\colwdtc}%
    \global\scrwdt\colwdtd\bodycol{#4}{\colwdtd}}%
  \vrulehgt=\dp0 \advance\vrulehgt by\addhgt%
  \body@row{\vrulehgt}{\box0}}}
\def\bodyrowiv[#1][#2][#3][#4][#5]{\ifnextchar[{\bodyrowv[#1][#2][#3][#4][#5]}{%
  \setbox0=\vbox{\hsize=\rowwdt%
    \hskip2pt\vtop{\hsize=\colwdta \global\scrwdt\colwdta #1}\hskip2pt%
    \global\scrwdt\colwdtb\bodycol{#2}{\colwdtb}%
    \global\scrwdt\colwdtc\bodycol{#3}{\colwdtc}%
    \global\scrwdt\colwdtd\bodycol{#4}{\colwdtd}%
    \global\scrwdt\colwdte\bodycol{#5}{\colwdte}}%
  \vrulehgt=\dp0 \advance\vrulehgt by\addhgt%
  \body@row{\vrulehgt}{\box0}}}
\def\bodyrowv[#1][#2][#3][#4][#5][#6]{%
  \ifnextchar[{\bodyrowvi[#1][#2][#3][#4][#5][#6]}{%
  \setbox0=\vbox{\hsize=\rowwdt%
    \hskip2pt\vtop{\hsize=\colwdta \global\scrwdt\colwdta #1}\hskip2pt%
    \global\scrwdt\colwdtb\bodycol{#2}{\colwdtb}%
    \global\scrwdt\colwdtc\bodycol{#3}{\colwdtc}%
    \global\scrwdt\colwdtd\bodycol{#4}{\colwdtd}%
    \global\scrwdt\colwdte\bodycol{#5}{\colwdte}%
    \global\scrwdt\colwdtf\bodycol{#6}{\colwdtf}}%
  \vrulehgt=\dp0 \advance\vrulehgt by\addhgt%
  \body@row{\vrulehgt}{\box0}}}
\def\bodyrowvi[#1][#2][#3][#4][#5][#6][#7]{%
  \ifnextchar[{\bodyrowvii[#1][#2][#3][#4][#5][#6][#7]}{%
  \setbox0=\vbox{\hsize=\rowwdt%
    \hskip2pt\vtop{\hsize=\colwdta \global\scrwdt\colwdta #1}\hskip2pt%
    \global\scrwdt\colwdtb\bodycol{#2}{\colwdtb}%
    \global\scrwdt\colwdtc\bodycol{#3}{\colwdtc}%
    \global\scrwdt\colwdtd\bodycol{#4}{\colwdtd}%
    \global\scrwdt\colwdte\bodycol{#5}{\colwdte}%
    \global\scrwdt\colwdtf\bodycol{#6}{\colwdtf}%
    \global\scrwdt\colwdtg\bodycol{#7}{\colwdtg}}%
  \vrulehgt=\dp0 \advance\vrulehgt by\addhgt%
  \body@row{\vrulehgt}{\box0}}}
\def\bodyrowvii[#1][#2][#3][#4][#5][#6][#7][#8]{%
  \ifnextchar[{\bodyrowviii[#1][#2][#3][#4][#5][#6][#7][#8]}{%
  \setbox0=\vbox{\hsize=\rowwdt%
    \hskip2pt\vtop{\hsize=\colwdta \global\scrwdt\colwdta #1}\hskip2pt%
    \global\scrwdt\colwdtb\bodycol{#2}{\colwdtb}%
    \global\scrwdt\colwdtc\bodycol{#3}{\colwdtc}%
    \global\scrwdt\colwdtd\bodycol{#4}{\colwdtd}%
    \global\scrwdt\colwdte\bodycol{#5}{\colwdte}%
    \global\scrwdt\colwdtf\bodycol{#6}{\colwdtf}%
    \global\scrwdt\colwdtg\bodycol{#7}{\colwdtg}%
    \global\scrwdt\colwdth\bodycol{#8}{\colwdth}}%
  \vrulehgt=\dp0 \advance\vrulehgt by\addhgt%
  \body@row{\vrulehgt}{\box0}}}
\def\bodyrowviii[#1][#2][#3][#4][#5][#6][#7][#8][#9]{%
  \setbox0=\vbox{\hsize=\rowwdt%
    \hskip2pt\vtop{\hsize=\colwdta \global\scrwdt\colwdta #1}\hskip2pt%
    \global\scrwdt\colwdtb\bodycol{#2}{\colwdtb}%
    \global\scrwdt\colwdtc\bodycol{#3}{\colwdtc}%
    \global\scrwdt\colwdtd\bodycol{#4}{\colwdtd}%
    \global\scrwdt\colwdte\bodycol{#5}{\colwdte}%
    \global\scrwdt\colwdtf\bodycol{#6}{\colwdtf}%
    \global\scrwdt\colwdtg\bodycol{#7}{\colwdtg}%
    \global\scrwdt\colwdth\bodycol{#8}{\colwdth}%
    \global\scrwdt\colwdti\bodycol{#9}{\colwdti}}%
  \vrulehgt=\dp0 \advance\vrulehgt by\addhgt%
  \body@row{\vrulehgt}{\box0}}
%
\def\numberline#1{\hspace{-5ex}\hb@xt@4ex{\hss#1}}

\def\chpter[#1]{\ifnextchar[{\reelchpter[#1]}{%
  \par\addvspace{2ex}% Başlığın üstündeki boşluk
  {\LARGE\bfseries\textcolor{hlcolor}{#1}\par}}}

\def\reelchpter[#1][#2]{%
  \par\addvspace{2ex}% Başlığın üstündeki boşluk
  {\numberline{\LARGE\bfseries\textcolor{hlcolor}{#2}}%
  \hspace{1ex}\LARGE\bfseries\textcolor{hlcolor}{#1}\par}}

\def\apendix[#1]{\ifnextchar[{\reelapendix[#1]}{%
  \par\addvspace{2ex}% Başlığın üstündeki boşluk
  {\LARGE\bfseries\textcolor{hlcolor}{#1}\par}}}

\def\reelapendix[#1][#2]{%
  \par\addvspace{2ex}% Başlığın üstündeki boşluk
  {\numberline{\LARGE\bfseries\textcolor{hlcolor}{#2}}%
  \hspace{1ex}\LARGE\bfseries\textcolor{hlcolor}{#1}\par}}

\def\sectone[#1]{\ifnextchar[{\reelsectone[#1]}{%
  \par\addvspace{2ex}% Başlığın üstündeki boşluk
  {\Large \bfseries \textcolor{hlcolor}{#1}\par}}}

\def\reelsectone[#1][#2]{%
  \par\addvspace{2ex}% Başlığın üstündeki boşluk
  {\Large \bfseries \textcolor{hlcolor}{#2\hspace{1ex}#1}\par}}

\def\secttwo[#1]{\ifnextchar[{\reelsecttwo[#1]}{%
  \par\addvspace{2ex}% Başlığın üstündeki boşluk
  \textcolor{hlcolor}{\large\bfseries #1}\par}}

\def\reelsecttwo[#1][#2]{%
  \par\addvspace{2ex}% Başlığın üstündeki boşluk
  {\large \bfseries \textcolor{hlcolor}{#2\hspace{1ex}#1}\par}}

\def\sectthree[#1]{\ifnextchar[{\reelsectthree[#1]}{%
  \par\addvspace{2ex}% Başlığın üstündeki boşluk
  {\normalsize \bfseries \textcolor{hlcolor}{#1}\par}}}

\def\reelsectthree[#1][#2]{%
  \par\addvspace{2ex}% Başlığın üstündeki boşluk
  {\normalsize \bfseries \textcolor{hlcolor}{#2\hspace{1ex}#1}\par}}

\def\sectfour[#1]{\ifnextchar[{\reelsectfour[#1]}{%
  \par\addvspace{2ex}% Başlığın üstündeki boşluk
  {\normalsize \bfseries \textcolor{hlcolor}{#1}\par}}}

\def\reelsectfour[#1][#2]{%
  \par\addvspace{2ex}% Başlığın üstündeki boşluk
  {\normalsize \bfseries \textcolor{hlcolor}{#2\hspace{1ex}#1}\par}}

\def\sectfive[#1]{\ifnextchar[{\reelsectfive[#1]}{%
  \par\addvspace{2ex}% Başlığın üstündeki boşluk
  {\normalsize \bfseries \textcolor{hlcolor}{#1}\par}}}

\def\reelsectfive[#1][#2]{%
  \par\addvspace{2ex}% Başlığın üstündeki boşluk
  {\normalsize \bfseries \textcolor{hlcolor}{#2\hspace{1ex}#1}\par}}

\def\refsectone#1{%
  \par\addvspace{1ex}{\large \bfseries #1\par}}

\def\refsecttwo#1{%
  \par\addvspace{1ex}{\hspace{2.5ex}\large \bfseries #1\par}}

\def\refsectthree#1{%
  \par\addvspace{1ex}{\hspace{5ex}\large \bfseries #1\par}}
%
\def\lbracket{\[}
\def\rbracket{\]}
\chardef\/="5C
\chardef\<="3C
\chardef\>="3E
\DeclareUnicodeCharacter{00B1}{\textplusminus}
\let\ifnextchar\@ifnextchar
\newcount\colcnt
\newdimen\indentwdt
\newdimen\indentedwdt
\newdimen\rowwdt
\newdimen\scrwdt
\newdimen\boxwdt%local
\newdimen\boxhgt%local
\newdimen\thisiw%local
\newdimen\thispw%local
\newdimen\addhgt
\newdimen\addindwdt
\newdimen\vrulehgt
\newdimen\colwdta
\newdimen\colwdtb
\newdimen\colwdtc
\newdimen\colwdtd
\newdimen\colwdte
\newdimen\colwdtf
\newdimen\colwdtg
\newdimen\colwdth
\newdimen\colwdti
\global\indentwdt0pt
\global\addhgt0.5pt
\global\addindwdt26pt
\newenvironment{itemizeditem}{\thisiw\indentwdt\advance\thisiw by-1\addindwdt%
  \list{}{\labelwidth\addindwdt \leftmargin\indentwdt \labelsep9pt \itemsep\z@ \topsep\z@}}
    {\endlist}
\newcommand*\mkitemlabel[1]{\boxwdt\addindwdt \advance\boxwdt by-9pt%
  \hbox to\boxwdt{\hss #1}}
\def\itempar#1#2{\begin{itemizeditem}\item[#1]{#2}\end{itemizeditem}}
\newenvironment{indenteditem}{\addvspace{-2ex}\list{}{\leftmargin\indentwdt \itemsep\z@ \topsep\z@}\item\relax}
    {\endlist}
\def\indentedpar#1{\begin{indenteditem}#1\end{indenteditem}}
\newenvironment{quoteditem}{\list{}{\leftmargin\indentwdt \rightmargin\indentwdt \itemsep\z@ \topsep\z@}\item\relax}
    {\endlist}
\def\quotedpar#1{\begin{quoteditem}#1\end{quoteditem}\vspace{3pt}}
\def\descrtitle#1{\reduceindent
  \begin{indenteditem}#1\vspace{-9pt}\end{indenteditem}
  \enhanceindent}
\endinput
%%
%% End of file `makaleps.cls'.
